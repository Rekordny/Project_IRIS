Includes = {
	"buttonstate.fxh"
	"sprite_animation.fxh"
}

PixelShader =
{
	Samplers =
	{
		MapTexture =
		{
			Index = 0
			MagFilter = "Linear"
			MinFilter = "Linear"
			MipFilter = "Linear"
			AddressU = "Clamp"
			AddressV = "Repeat"
		}
	}
}

VertexStruct VS_OUTPUT
{
	float4  vPosition : PDX_POSITION;
	float2  vTexCoord : TEXCOORD0;
	float2  vAnimTexCoord : TEXCOORD1;
	float   vAnimProgress : TEXCOORD2;
#ifdef ANIMATED
	float4  vAnimatedTexCoord : TEXCOORD3;
#endif
#ifdef MASKING
	float2  vMaskingTexCoord : TEXCOORD4;
#endif
};

VertexShader =
{
	MainCode VertexShader
	[[
		VS_OUTPUT main(const VS_INPUT v )
		{
		    VS_OUTPUT Out;
		    Out.vPosition  = mul( WorldViewProjectionMatrix, float4( v.vPosition.xyz, 1 ) );
		    Out.vTexCoord = v.vTexCoord;
			
			float animTime = Time - AnimationTime;
			// 动画时长保持0.5秒（之前修改的加快效果）
			Out.vAnimProgress = min(animTime / 0.5f, 1.0f);
			
			// 顶点着色器仅提供基础时间进度，滚动逻辑由像素着色器按方向处理
			float scrollIntensity = smoothstep(0.0f, 1.0f, Out.vAnimProgress);
			Out.vAnimTexCoord = float2(v.vTexCoord.x, v.vTexCoord.y + scrollIntensity);
			
		#ifdef ANIMATED
			//Out.vAnimatedTexCoord = GetAnimatedTexcoord(v.vTexCoord);	
		#endif

		#ifdef MASKING
			Out.vMaskingTexCoord = smoothstep(0.0, 0.01, v.vTexCoord); 
		#endif
		
		    return Out;
		}
	]]
}

PixelShader =
{
	MainCode PixelShaderUp
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
		    float vTime = Time - AnimationTime;
		    float value = floor((Offset.x) * 10.f) + 1.f;
			float commaVal = floor(value / 1000000.f);
			float endVal = floor(value / 1000.f) - (commaVal * 1000.f);
			float startVal = value - (endVal * 1000.f) - (commaVal * 1000000.f);
			
			float animProgress = v.vAnimProgress;
			bool isAnimFinished = (animProgress >= 1.0f); // 动画是否完全结束
			
			// 1. 拆分起始值和目标值的各位（0-9范围限制）
			// 起始值
			float startHun = clamp(floor(startVal / 100.f), 0.0f, 9.0f);
			float startTen = clamp(floor((startVal - startHun * 100.f) / 10.f), 0.0f, 9.0f);
			float startOne = clamp(floor(startVal - startHun * 100.f - startTen * 10.f), 0.0f, 9.0f);
			
			// 目标值
			float endHun = clamp(floor(endVal / 100.f), 0.0f, 9.0f);
			float endTen = clamp(floor((endVal - endHun * 100.f) / 10.f), 0.0f, 9.0f);
			float endOne = clamp(floor(endVal - endHun * 100.f - endTen * 10.f), 0.0f, 9.0f);
			
			float pointOne = 0.1f/3.f;   // 百位/十位分割点（0.0333）
			float pointTwo = pointOne * 2.f; // 十位/个位分割点（0.0666）
			float smoothEdge = 0.005f;
			float4 OutColour = float4(0,0,0,0);
			
			// 2. 百位独立动画逻辑（区分上下滚动）
			{
				float currentNum = startHun;
				float nextNum = startHun;
				float currentWeight = 1.0f;
				float nextWeight = 0.0f;
				float texY = v.vTexCoord.y;
				
				// 计算原始差值（保留正负，判断增减方向）
				float deltaHun = endHun - startHun;
				bool isHunUp = (deltaHun > 0.001f);    // 数字变大 → 向上滚
				bool isHunDown = (deltaHun < -0.001f); // 数字变小 → 向下滚
				float hunRollCount = isHunUp ? deltaHun : (isHunDown ? -deltaHun : 0.0f);
				bool isHunAnim = (hunRollCount > 0.001f);
				
				// 动画过程中：按方向计算当前数字、偏移和权重
				if (isHunAnim && !isAnimFinished) {
					float scrollOffset = animProgress * hunRollCount; // 总滚动偏移（进度×次数）
					float rolledTimes = floor(scrollOffset);          // 已完成滚动次数
					float currentRollProgress = frac(scrollOffset);   // 当前滚动周期进度
					
					if (isHunUp) {
						// 向上滚（数字递增）：当前数字=起始+已滚次数（0-9循环）
						currentNum = (startHun + rolledTimes) % 10.0f;
						nextNum = (currentNum + 1.0f) % 10.0f; // 下一个递增数字
						texY = v.vTexCoord.y + scrollOffset;   // Y轴向上偏移（符合向上滚动视觉）
					} else { // isHunDown
						// 向下滚（数字递减）：当前数字=起始-已滚次数（+10避免负数，0-9循环）
						currentNum = (startHun - rolledTimes + 10.0f) % 10.0f;
						nextNum = (currentNum - 1.0f + 10.0f) % 10.0f; // 下一个递减数字
						texY = v.vTexCoord.y - scrollOffset;   // Y轴向下偏移（符合向下滚动视觉）
					}
					
					// 过渡权重（当前数字权重递减，下一个数字权重递增）
					currentWeight = 1.0f - currentRollProgress;
					nextWeight = currentRollProgress;
				}
				// 动画结束：直接显示目标值
				else if (isAnimFinished) {
					currentNum = endHun;
				}
				
				// 采样当前数字
				float weightCurrent = smoothstep(-smoothEdge, smoothEdge, pointOne - v.vTexCoord.x) * currentWeight;
				if (weightCurrent > 0.f) {
					float xPoint = 0.1f * currentNum;
					float2 texCoord = float2(xPoint + v.vTexCoord.x, texY);
					OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightCurrent);
				}
				
				// 采样下一个数字（根据方向调整进入位置）
				if (isHunAnim && !isAnimFinished && nextWeight > 0.f) {
					float weightNext = smoothstep(-smoothEdge, smoothEdge, pointOne - v.vTexCoord.x) * nextWeight;
					if (weightNext > 0.f) {
						float xPoint = 0.1f * nextNum;
						float2 texCoord;
						if (isHunUp) {
							texCoord = float2(xPoint + v.vTexCoord.x, texY - 1.0f); // 向上滚：下一个数字从下方进入
						} else {
							texCoord = float2(xPoint + v.vTexCoord.x, texY + 1.0f); // 向下滚：下一个数字从上方进入
						}
						OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightNext);
					}
				}
			}
			
			// 3. 十位独立动画逻辑（与百位完全一致，仅变量替换）
			{
				float currentNum = startTen;
				float nextNum = startTen;
				float currentWeight = 1.0f;
				float nextWeight = 0.0f;
				float texY = v.vTexCoord.y;
				
				float deltaTen = endTen - startTen;
				bool isTenUp = (deltaTen > 0.001f);
				bool isTenDown = (deltaTen < -0.001f);
				float tenRollCount = isTenUp ? deltaTen : (isTenDown ? -deltaTen : 0.0f);
				bool isTenAnim = (tenRollCount > 0.001f);
				
				if (isTenAnim && !isAnimFinished) {
					float scrollOffset = animProgress * tenRollCount;
					float rolledTimes = floor(scrollOffset);
					float currentRollProgress = frac(scrollOffset);
					
					if (isTenUp) {
						currentNum = (startTen + rolledTimes) % 10.0f;
						nextNum = (currentNum + 1.0f) % 10.0f;
						texY = v.vTexCoord.y + scrollOffset;
					} else {
						currentNum = (startTen - rolledTimes + 10.0f) % 10.0f;
						nextNum = (currentNum - 1.0f + 10.0f) % 10.0f;
						texY = v.vTexCoord.y - scrollOffset;
					}
					
					currentWeight = 1.0f - currentRollProgress;
					nextWeight = currentRollProgress;
				}
				else if (isAnimFinished) {
					currentNum = endTen;
				}
				
				float weightCurrent = smoothstep(smoothEdge, -smoothEdge, pointOne - v.vTexCoord.x) 
					* smoothstep(-smoothEdge, smoothEdge, pointTwo - v.vTexCoord.x) * currentWeight;
				if (weightCurrent > 0.f) {
					float xPoint = 0.1f * currentNum;
					float2 texCoord = float2(xPoint + (v.vTexCoord.x - pointOne), texY);
					OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightCurrent);
				}
				
				if (isTenAnim && !isAnimFinished && nextWeight > 0.f) {
					float weightNext = smoothstep(smoothEdge, -smoothEdge, pointOne - v.vTexCoord.x) 
						* smoothstep(-smoothEdge, smoothEdge, pointTwo - v.vTexCoord.x) * nextWeight;
					if (weightNext > 0.f) {
						float xPoint = 0.1f * nextNum;
						float2 texCoord;
						if (isTenUp) {
							texCoord = float2(xPoint + (v.vTexCoord.x - pointOne), texY - 1.0f);
						} else {
							texCoord = float2(xPoint + (v.vTexCoord.x - pointOne), texY + 1.0f);
						}
						OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightNext);
					}
				}
			}
			
			// 4. 个位独立动画逻辑（与百位完全一致，仅变量替换）
			{
				float currentNum = startOne;
				float nextNum = startOne;
				float currentWeight = 1.0f;
				float nextWeight = 0.0f;
				float texY = v.vTexCoord.y;
				
				float deltaOne = endOne - startOne;
				bool isOneUp = (deltaOne > 0.001f);
				bool isOneDown = (deltaOne < -0.001f);
				float oneRollCount = isOneUp ? deltaOne : (isOneDown ? -deltaOne : 0.0f);
				bool isOneAnim = (oneRollCount > 0.001f);
				
				if (isOneAnim && !isAnimFinished) {
					float scrollOffset = animProgress * oneRollCount;
					float rolledTimes = floor(scrollOffset);
					float currentRollProgress = frac(scrollOffset);
					
					if (isOneUp) {
						currentNum = (startOne + rolledTimes) % 10.0f;
						nextNum = (currentNum + 1.0f) % 10.0f;
						texY = v.vTexCoord.y + scrollOffset;
					} else {
						currentNum = (startOne - rolledTimes + 10.0f) % 10.0f;
						nextNum = (currentNum - 1.0f + 10.0f) % 10.0f;
						texY = v.vTexCoord.y - scrollOffset;
					}
					
					currentWeight = 1.0f - currentRollProgress;
					nextWeight = currentRollProgress;
				}
				else if (isAnimFinished) {
					currentNum = endOne;
				}
				
				float weightCurrent = smoothstep(smoothEdge, -smoothEdge, pointTwo - v.vTexCoord.x) * currentWeight;
				if (weightCurrent > 0.f) {
					float xPoint = 0.1f * currentNum;
					float2 texCoord = float2(xPoint + (v.vTexCoord.x - pointTwo), texY);
					OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightCurrent);
				}
				
				if (isOneAnim && !isAnimFinished && nextWeight > 0.f) {
					float weightNext = smoothstep(smoothEdge, -smoothEdge, pointTwo - v.vTexCoord.x) * nextWeight;
					if (weightNext > 0.f) {
						float xPoint = 0.1f * nextNum;
						float2 texCoord;
						if (isOneUp) {
							texCoord = float2(xPoint + (v.vTexCoord.x - pointTwo), texY - 1.0f);
						} else {
							texCoord = float2(xPoint + (v.vTexCoord.x - pointTwo), texY + 1.0f);
						}
						OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightNext);
					}
				}
			}

			OutColour.a = saturate(OutColour.a);
			return OutColour;
		}
	]]

	MainCode PixelShaderDown
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
		    float4 OutColor = tex2D( MapTexture, v.vTexCoord );
					
		#ifdef ANIMATED
			OutColor = Animate(OutColor, v.vTexCoord, v.MapTexture, MapTexture, MapTexture, MapTexture, MapTexture);
		#endif

		#ifdef MASKING
			float4 MaskColor = tex2D( MaskingTexture, v.vTexCoord );
			OutColor.a *= smoothstep(0.0, 0.01, MaskColor.a);
		#endif
			
			OutColor *= Color;
			OutColor.a = saturate(OutColor.a);
			return OutColor;
		}
	]]

	MainCode PixelShaderDisable
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
		    float vTime = Time - AnimationTime;
		    float value = floor((Offset.x) * 10.f) + 1.f;
			float commaVal = floor(value / 1000000.f);
			float endVal = floor(value / 1000.f) - (commaVal * 1000.f);
			float startVal = value - (endVal * 1000.f) - (commaVal * 1000000.f);
			
			float animProgress = v.vAnimProgress;
			bool isAnimFinished = (animProgress >= 1.0f); // 动画是否完全结束
			
			// 1. 拆分起始值和目标值的各位（0-9范围限制）
			// 起始值
			float startHun = clamp(floor(startVal / 100.f), 0.0f, 9.0f);
			float startTen = clamp(floor((startVal - startHun * 100.f) / 10.f), 0.0f, 9.0f);
			float startOne = clamp(floor(startVal - startHun * 100.f - startTen * 10.f), 0.0f, 9.0f);
			
			// 目标值
			float endHun = clamp(floor(endVal / 100.f), 0.0f, 9.0f);
			float endTen = clamp(floor((endVal - endHun * 100.f) / 10.f), 0.0f, 9.0f);
			float endOne = clamp(floor(endVal - endHun * 100.f - endTen * 10.f), 0.0f, 9.0f);
			
			float pointOne = 0.1f/3.f;   // 百位/十位分割点（0.0333）
			float pointTwo = pointOne * 2.f; // 十位/个位分割点（0.0666）
			float smoothEdge = 0.005f;
			float4 OutColour = float4(0,0,0,0);
			
			// 2. 百位独立动画逻辑（区分上下滚动）
			{
				float currentNum = startHun;
				float nextNum = startHun;
				float currentWeight = 1.0f;
				float nextWeight = 0.0f;
				float texY = v.vTexCoord.y;
				
				float deltaHun = endHun - startHun;
				bool isHunUp = (deltaHun > 0.001f);
				bool isHunDown = (deltaHun < -0.001f);
				float hunRollCount = isHunUp ? deltaHun : (isHunDown ? -deltaHun : 0.0f);
				bool isHunAnim = (hunRollCount > 0.001f);
				
				if (isHunAnim && !isAnimFinished) {
					float scrollOffset = animProgress * hunRollCount;
					float rolledTimes = floor(scrollOffset);
					float currentRollProgress = frac(scrollOffset);
					
					if (isHunUp) {
						currentNum = (startHun + rolledTimes) % 10.0f;
						nextNum = (currentNum + 1.0f) % 10.0f;
						texY = v.vTexCoord.y + scrollOffset;
					} else {
						currentNum = (startHun - rolledTimes + 10.0f) % 10.0f;
						nextNum = (currentNum - 1.0f + 10.0f) % 10.0f;
						texY = v.vTexCoord.y - scrollOffset;
					}
					
					currentWeight = 1.0f - currentRollProgress;
					nextWeight = currentRollProgress;
				}
				else if (isAnimFinished) {
					currentNum = endHun;
				}
				
				float weightCurrent = smoothstep(-smoothEdge, smoothEdge, pointOne - v.vTexCoord.x) * currentWeight;
				if (weightCurrent > 0.f) {
					float xPoint = 0.1f * currentNum;
					float2 texCoord = float2(xPoint + v.vTexCoord.x, texY);
					OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightCurrent);
				}
				
				if (isHunAnim && !isAnimFinished && nextWeight > 0.f) {
					float weightNext = smoothstep(-smoothEdge, smoothEdge, pointOne - v.vTexCoord.x) * nextWeight;
					if (weightNext > 0.f) {
						float xPoint = 0.1f * nextNum;
						float2 texCoord = isHunUp ? 
							float2(xPoint + v.vTexCoord.x, texY - 1.0f) : 
							float2(xPoint + v.vTexCoord.x, texY + 1.0f);
						OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightNext);
					}
				}
			}
			
			// 3. 十位独立动画逻辑（与百位完全一致）
			{
				float currentNum = startTen;
				float nextNum = startTen;
				float currentWeight = 1.0f;
				float nextWeight = 0.0f;
				float texY = v.vTexCoord.y;
				
				float deltaTen = endTen - startTen;
				bool isTenUp = (deltaTen > 0.001f);
				bool isTenDown = (deltaTen < -0.001f);
				float tenRollCount = isTenUp ? deltaTen : (isTenDown ? -deltaTen : 0.0f);
				bool isTenAnim = (tenRollCount > 0.001f);
				
				if (isTenAnim && !isAnimFinished) {
					float scrollOffset = animProgress * tenRollCount;
					float rolledTimes = floor(scrollOffset);
					float currentRollProgress = frac(scrollOffset);
					
					if (isTenUp) {
						currentNum = (startTen + rolledTimes) % 10.0f;
						nextNum = (currentNum + 1.0f) % 10.0f;
						texY = v.vTexCoord.y + scrollOffset;
					} else {
						currentNum = (startTen - rolledTimes + 10.0f) % 10.0f;
						nextNum = (currentNum - 1.0f + 10.0f) % 10.0f;
						texY = v.vTexCoord.y - scrollOffset;
					}
					
					currentWeight = 1.0f - currentRollProgress;
					nextWeight = currentRollProgress;
				}
				else if (isAnimFinished) {
					currentNum = endTen;
				}
				
				float weightCurrent = smoothstep(smoothEdge, -smoothEdge, pointOne - v.vTexCoord.x) 
					* smoothstep(-smoothEdge, smoothEdge, pointTwo - v.vTexCoord.x) * currentWeight;
				if (weightCurrent > 0.f) {
					float xPoint = 0.1f * currentNum;
					float2 texCoord = float2(xPoint + (v.vTexCoord.x - pointOne), texY);
					OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightCurrent);
				}
				
				if (isTenAnim && !isAnimFinished && nextWeight > 0.f) {
					float weightNext = smoothstep(smoothEdge, -smoothEdge, pointOne - v.vTexCoord.x) 
						* smoothstep(-smoothEdge, smoothEdge, pointTwo - v.vTexCoord.x) * nextWeight;
					if (weightNext > 0.f) {
						float xPoint = 0.1f * nextNum;
						float2 texCoord = isTenUp ? 
							float2(xPoint + (v.vTexCoord.x - pointOne), texY - 1.0f) : 
							float2(xPoint + (v.vTexCoord.x - pointOne), texY + 1.0f);
						OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightNext);
					}
				}
			}
			
			// 4. 个位独立动画逻辑（与百位完全一致）
			{
				float currentNum = startOne;
				float nextNum = startOne;
				float currentWeight = 1.0f;
				float nextWeight = 0.0f;
				float texY = v.vTexCoord.y;
				
				float deltaOne = endOne - startOne;
				bool isOneUp = (deltaOne > 0.001f);
				bool isOneDown = (deltaOne < -0.001f);
				float oneRollCount = isOneUp ? deltaOne : (isOneDown ? -deltaOne : 0.0f);
				bool isOneAnim = (oneRollCount > 0.001f);
				
				if (isOneAnim && !isAnimFinished) {
					float scrollOffset = animProgress * oneRollCount;
					float rolledTimes = floor(scrollOffset);
					float currentRollProgress = frac(scrollOffset);
					
					if (isOneUp) {
						currentNum = (startOne + rolledTimes) % 10.0f;
						nextNum = (currentNum + 1.0f) % 10.0f;
						texY = v.vTexCoord.y + scrollOffset;
					} else {
						currentNum = (startOne - rolledTimes + 10.0f) % 10.0f;
						nextNum = (currentNum - 1.0f + 10.0f) % 10.0f;
						texY = v.vTexCoord.y - scrollOffset;
					}
					
					currentWeight = 1.0f - currentRollProgress;
					nextWeight = currentRollProgress;
				}
				else if (isAnimFinished) {
					currentNum = endOne;
				}
				
				float weightCurrent = smoothstep(smoothEdge, -smoothEdge, pointTwo - v.vTexCoord.x) * currentWeight;
				if (weightCurrent > 0.f) {
					float xPoint = 0.1f * currentNum;
					float2 texCoord = float2(xPoint + (v.vTexCoord.x - pointTwo), texY);
					OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightCurrent);
				}
				
				if (isOneAnim && !isAnimFinished && nextWeight > 0.f) {
					float weightNext = smoothstep(smoothEdge, -smoothEdge, pointTwo - v.vTexCoord.x) * nextWeight;
					if (weightNext > 0.f) {
						float xPoint = 0.1f * nextNum;
						float2 texCoord = isOneUp ? 
							float2(xPoint + (v.vTexCoord.x - pointTwo), texY - 1.0f) : 
							float2(xPoint + (v.vTexCoord.x - pointTwo), texY + 1.0f);
						OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightNext);
					}
				}
			}

			OutColour.a = saturate(OutColour.a);
			return OutColour;
		}	
	]]
}

BlendState BlendState
{
	BlendEnable = yes
	SourceBlend = "src_alpha"
	DestBlend = "inv_src_alpha"
	BlendOp = "add"
	AlphaBlendEnable = yes
	SourceAlphaBlend = "src_alpha"
	DestAlphaBlend = "inv_src_alpha"
	AlphaBlendOp = "add"
}

Effect Up
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShaderUp"
	BlendState = "BlendState"
}

Effect Down
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShaderDown"
	BlendState = "BlendState"
}

Effect Disable
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShaderDisable"
	BlendState = "BlendState"
}