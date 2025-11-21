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
    float   vAnimProgress : TEXCOORD1;
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
            // 动画时长保持0.5秒
            Out.vAnimProgress = min(animTime / 0.5f, 1.0f);
            
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
            
            // 2. 百位独立动画逻辑
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
                // --- 新增代码：动画结束后上下浮动 ---
                else if (isAnimFinished) {
                    currentNum = endHun;
                    // 使用sin函数创建周期性浮动，Time是全局时间
                    // 1.5f是频率，0.02f是浮动幅度，可以调整
                    float floatOffset = sin(Time * 1.5f) * 0.02f;
                    texY = v.vTexCoord.y + floatOffset;
                }
                // ------------------------------------
                
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
                        float2 texCoord;
                        if (isHunUp) {
                            texCoord = float2(xPoint + v.vTexCoord.x, texY - 1.0f);
                        } else {
                            texCoord = float2(xPoint + v.vTexCoord.x, texY + 1.0f);
                        }
                        OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), weightNext);
                    }
                }
            }
            
            // 3. 十位独立动画逻辑
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
                // --- 新增代码：动画结束后上下浮动 ---
                else if (isAnimFinished) {
                    currentNum = endTen;
                    // 使用不同的频率（2.0f）和相位偏移（1.0f），让浮动效果不同步
                    float floatOffset = sin(Time * 2.0f + 1.0f) * 0.02f;
                    texY = v.vTexCoord.y + floatOffset;
                }
                // ------------------------------------
                
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
            
            // 4. 个位独立动画逻辑
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
                // --- 新增代码：动画结束后上下浮动 ---
                else if (isAnimFinished) {
                    currentNum = endOne;
                    // 使用另一种频率（1.2f）和相位偏移（2.5f）
                    float floatOffset = sin(Time * 1.2f + 2.5f) * 0.02f;
                    texY = v.vTexCoord.y + floatOffset;
                }
                // ------------------------------------
                
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
            
            // 2. 百位独立动画逻辑
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
                // --- 新增代码：动画结束后上下浮动 ---
                else if (isAnimFinished) {
                    currentNum = endHun;
                    float floatOffset = sin(Time * 1.5f) * 0.02f;
                    texY = v.vTexCoord.y + floatOffset;
                }
                // ------------------------------------
                
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
            
            // 3. 十位独立动画逻辑
            {
                float currentNum = startTen;
                float nextNum = startTen;
                float currentWeight = 1.0f;
                float nextWeight = 0.0f;
                float texY = v.vTexCoord.y;
                
                float deltaTen = endTen - startTen;
                bool isTenUp = (deltaTen > 0.001f);
                bool isTenDown = (deltaTen < -0.001f);
                float tenRollCount = isTenUp ? deltaTen : (deltaTen ? -deltaTen : 0.0f);
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
                // --- 新增代码：动画结束后上下浮动 ---
                else if (isAnimFinished) {
                    currentNum = endTen;
                    float floatOffset = sin(Time * 2.0f + 1.0f) * 0.02f;
                    texY = v.vTexCoord.y + floatOffset;
                }
                // ------------------------------------
                
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
            
            // 4. 个位独立动画逻辑
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
                // --- 新增代码：动画结束后上下浮动 ---
                else if (isAnimFinished) {
                    currentNum = endOne;
                    float floatOffset = sin(Time * 1.2f + 2.5f) * 0.02f;
                    texY = v.vTexCoord.y + floatOffset;
                }
                // ------------------------------------
                
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
                        OutColour = lerp(OutColour, tex2D(MapTexture, texCoord), nextWeight);
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