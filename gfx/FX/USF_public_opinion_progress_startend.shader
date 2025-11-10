Includes = {
	"buttonstate.fxh"
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
			MipFilter = "None"
			AddressU = "Clamp"
			AddressV = "Clamp"
			MipMapLodBias = -0.8
		}
		MaskTexture =
		{
			Index = 1
			MagFilter = "Linear"
			MinFilter = "Linear"
			MipFilter = "None"
			AddressU = "Clamp"
			AddressV = "Clamp"
		}
		AnimatedTexture =
		{
			Index = 2
			MagFilter = "Linear"
			MinFilter = "Linear"
			MipFilter = "None"
			AddressU = "Wrap"
			AddressV = "Wrap"
		}
		MaskTexture2 =
		{
			Index = 3
			MagFilter = "Linear"
			MinFilter = "Linear"
			MipFilter = "None"
			AddressU = "Clamp"
			AddressV = "Clamp"
		}
		AnimatedTexture2 =
		{
			Index = 4
			MagFilter = "Linear"
			MinFilter = "Linear"
			MipFilter = "None"
			AddressU = "Wrap"
			AddressV = "Wrap"
		}
		MaskingTexture =
		{
			Index = 5
			MagFilter = "Point"
			MinFilter = "Point"
			MipFilter = "None"
			AddressU = "Clamp"
			AddressV = "Clamp"
		}
	}
}

VertexStruct VS_OUTPUT
{
	float4  vPosition : PDX_POSITION;
	float2  vTexCoord : TEXCOORD0;
};

VertexShader =
{
	MainCode VertexShaderMain
	[[
		VS_OUTPUT main(const VS_INPUT v )
		{
			float vTime = Time - AnimationTime;
			// 解析Offset.x：格式 = 结束宽度比例（百分制）*1000 + 起始宽度比例（百分制）
			float startPercent = fmod(Offset.x, 1000.f);
			float endPercent = floor(Offset.x / 1000.f);
			
			float startRatio = clamp(startPercent / 100.f, 0.f, 1.f);
			float endRatio = clamp(endPercent / 100.f, 0.f, 1.f);
			
			// 缓动过渡（保持原动画曲线，确保平滑）
			float t = clamp(vTime, 0.f, 0.5f);
			float easeT = (1.f - sin((4.f * t - 1.f) * 1.57079633f)) / 2.f;
			float currentRatio = lerp(startRatio, endRatio, easeT);
			
			// 由于偏移计算问题 目标值需+8
			float originalWidth = 776.0f;
			float validWidth = originalWidth * currentRatio;
			
			VS_OUTPUT Out;
			// 步骤1：顶点裁剪（仅保留左侧≤validWidth的区域，右侧裁切）
			float finalX = min(v.vPosition.x, validWidth);
			
			// 步骤2：纹理坐标修正（确保可见区域的纹理和原图1:1，无压缩）
			// 原图纹理U坐标范围是0→1，对应像素0→768；可见区域U坐标按有效宽度等比缩放
			float texU = v.vTexCoord.x * currentRatio;
			
			Out.vPosition = mul(WorldViewProjectionMatrix, float4(finalX, v.vPosition.yz, 1.f));
			Out.vTexCoord = float2(texU, v.vTexCoord.y);
			return Out;
		}
	]]
}

PixelShader =
{
	MainCode PixelShaderMain
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			// 采样时仅可见有效纹理区域，确保无变形
			return tex2D(MapTexture, v.vTexCoord);
		}
	]]
}

BlendState BlendState
{
	BlendEnable = yes
	SourceBlend = "src_alpha"
	DestBlend = "inv_src_alpha"
}

Effect Up
{
	VertexShader = "VertexShaderMain"
	PixelShader = "PixelShaderMain"
}

Effect Down
{
	VertexShader = "VertexShaderMain"
	PixelShader = "PixelShaderMain"
}

Effect Disable
{
	VertexShader = "VertexShaderMain"
	PixelShader = "PixelShaderMain"
}

Effect Over
{
	VertexShader = "VertexShaderMain"
	PixelShader = "PixelShaderMain"
}