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
			// 核心修改：前6位数字缩小10倍（解决载入问题）+ 角度控制
			// 新格式（Offset.x 为6位整数）：
			// 第1-4位：缩小后的前6位（原前3位/10 取整 + 原后3位/10 取整 拼接）
			// 第5位：当前角度编码（1-7对应角度，其余默认0°）
			// 第6位：目标角度编码（1-7对应角度，其余默认0°）
			// 还原规则：前4位拆为前2位+后2位，各自×10 → 还原为原量级前6位
			// 示例：原前6位192135 → 192/10=19，135/10=14 → 缩小后前4位1914 → 着色器内19×10=190，14×10=140 → 还原为190140
			// ==============================================
			// 1. 提取Offset.x整数部分（避免小数干扰，确保位解析准确）
			int totalInt = floor(Offset.x); // 例：输入191415 → totalInt=191415（前4位1914 + 角度15）

			// 2. 分离各部分：缩小后的前4位、第5位（当前编码）、第6位（目标编码）
			int shrinkedFront4 = totalInt / 100;          // 前4位（缩小后的前6位）：总整数÷100取整 → 191415÷100=1914
			int currentAngleCode = (totalInt / 10) % 10;  // 第5位（当前角度编码）：÷10后取余10 → 191415÷10=19141 → 19141%10=1
			int targetAngleCode = totalInt % 10;          // 第6位（目标角度编码）：取余10 → 191415%10=5

			// 3. 还原原量级前6位（核心：缩小后→原大小）
			int high2 = shrinkedFront4 / 100;  // 前4位的前2位 → 1914÷100=19
			int low2 = shrinkedFront4 % 100;   // 前4位的后2位 → 1914%100=14
			int frontSix = high2 * 10 * 1000 + low2 * 10; // 还原为原量级前6位：19×10=190，14×10=140 → 190×1000+140=190140

			// 4. 保留原功能逻辑：基于还原后的前6位计算vPrevIndex和vNextIndex
			float vNextIndex = mod(frontSix, 1000.f);   // 原逻辑：前6位的后三位 → 190140%1000=140
			float vPrevIndex = floor(frontSix / 1000.f); // 原逻辑：前6位的前三位 → 190140÷1000=190

			// ==============================================
			// 角度控制逻辑（保留原有规则）
			// ==============================================
			// 角度编码映射表（可直接修改对应角度，无需改其他逻辑）
			float angleMap[10] = {
				0.0f,   // 编码0 → 默认0°（异常编码）
				-25.0f, // 编码1 → -25°（可修改）
				-15.0f, // 编码2 → -15°（可修改）
				-5.0f,  // 编码3 → -5°（可修改）
				0.0f,   // 编码4 → 0°（可修改）
				5.0f,   // 编码5 → 5°（可修改）
				15.0f,  // 编码6 → 15°（可修改）
				25.0f,  // 编码7 → 25°（可修改）
				0.0f,   // 编码8 → 默认0°（异常编码）
				0.0f    // 编码9 → 默认0°（异常编码）
			};

			// 获取当前角度和目标角度（clamp避免编码越界）
			float currentAngle = angleMap[clamp(currentAngleCode, 0, 9)];
			float targetAngle = angleMap[clamp(targetAngleCode, 0, 9)];

			// 角度平滑过渡（可调整速度或关闭）
			float transitionTime = 1.0f; // 过渡时长（0.5f=快速，2.0f=慢速，可修改）
			float t = clamp(vTime / transitionTime, 0.0f, 1.0f); // 过渡进度（0→1）
			float finalAngle = lerp(currentAngle, targetAngle, t); // 平滑插值

			// 角度转弧度（HLSL三角函数需弧度输入）
			float rotationRadians = radians(finalAngle);
			float cosAngle = cos(rotationRadians);
			float sinAngle = sin(rotationRadians);

			// ==============================================
			// 原有旋转+偏移逻辑（无变形核心）
			// ==============================================
			float originalX = v.vPosition.x;
			float originalY = v.vPosition.y;

			// 标准2D旋转矩阵（无拉伸变形）
			float rotatedX = originalX * cosAngle - originalY * sinAngle;
			float rotatedY = originalX * sinAngle + originalY * cosAngle;

			// 最终顶点位置（旋转+原偏移+投影变换）
			VS_OUTPUT Out;
			Out.vPosition = mul(WorldViewProjectionMatrix, float4(
				rotatedX + ((vPrevIndex - vNextIndex) * spacingBetweenIndices) * (1.f - sin((4.f * clamp(vTime, 0.f, 0.5f) - 1.f) * 1.57079633f)) / 2.f, 
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