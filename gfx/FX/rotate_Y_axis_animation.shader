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
			float spacingBetweenIndices = 1.901f;

			// ==============================================
			// 原有索引解析逻辑（保留）
			// ==============================================
			int totalInt = floor(Offset.x);
			int shrinkedFront4 = totalInt / 100;
			int currentAngleCode = (totalInt / 10) % 10;
			int targetAngleCode = totalInt % 10;

			int high2 = shrinkedFront4 / 100;
			int low2 = shrinkedFront4 % 100;
			int frontSix = high2 * 10 * 1000 + low2 * 10;

			float vNextIndex = mod(frontSix, 1000.f);
			float vPrevIndex = floor(frontSix / 1000.f);

			// ==============================================
			// 角度映射表（保留）
			// ==============================================
			float angleMap[10] = {
				0.0f,   // 0
				-25.0f, // 1
				-15.0f, // 2
				-5.0f,  // 3
				0.0f,   // 4
				5.0f,   // 5
				15.0f,  // 6
				25.0f,  // 7
				0.0f,   // 8
				0.0f    // 9
			};

			float currentAngle = angleMap[clamp(currentAngleCode, 0, 9)];
			float targetAngle = angleMap[clamp(targetAngleCode, 0, 9)];

			// ==============================================
			// 核心修改：旋转与移动同步（时长+进度完全对齐）
			// ==============================================
			// 1. 移动的总时长（从原代码提取：clamp(vTime, 0.f, 0.5f) → 移动时长0.5秒）
			float moveTotalTime = 0.5f;

			// 2. 旋转过渡时长 = 移动时长（强制同步），旋转变快（从1秒→0.5秒）
			float rotationTransitionTime = moveTotalTime;

			// 3. 进度同步：旋转进度与移动进度完全绑定（同一时间窗口+同一进度曲线）
			// 原移动进度：(4.f * clamp(vTime, 0.f, 0.5f) - 1.f) * 1.57079633f
			// 旋转进度直接复用移动的时间钳位，确保0→0.5秒内同时完成
			float timeClamped = clamp(vTime, 0.f, moveTotalTime); // 统一时间窗口（0-0.5秒）
			float t = timeClamped / rotationTransitionTime;       // 进度同步（0→1，0.5秒内完成）
			float finalAngle = lerp(currentAngle, targetAngle, t); // 快速旋转插值

			// ==============================================
			// 旋转计算（保留中心点旋转逻辑）
			// ==============================================
			float rotationRadians = radians(finalAngle);
			float cosAngle = cos(rotationRadians);
			float sinAngle = sin(rotationRadians);

			float originalX = v.vPosition.x;
			float originalY = v.vPosition.y;

			// 中心点（根据顶点坐标范围调整，默认0-1标准化坐标）
			float centerX = 0.5f;
			float centerY = 0.5f;

			// 平移→旋转→平移回（中心点旋转逻辑保留）
			float translatedX = originalX - centerX;
			float translatedY = originalY - centerY;
			float rotatedX = translatedX * cosAngle - translatedY * sinAngle;
			float rotatedY = translatedX * sinAngle + translatedY * cosAngle;
			rotatedX += centerX;
			rotatedY += centerY;

			// ==============================================
			// 原有移动逻辑（保留，与旋转进度同步）
			// ==============================================
			VS_OUTPUT Out;
			Out.vPosition = mul(WorldViewProjectionMatrix, float4(
				rotatedX + ((vPrevIndex - vNextIndex) * spacingBetweenIndices) * (1.f - sin((4.f * timeClamped - 1.f) * 1.57079633f)) / 2.f, 
				rotatedY, 
				v.vPosition.z, 
				1.f
			));
			Out.vTexCoord = v.vTexCoord;
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