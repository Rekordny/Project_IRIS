Includes = {
    "buttonstate.fxh",
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
            AddressV = "Clamp"
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
            Out.vAnimProgress = min(animTime / 0.5f, 1.0f);
            
        #ifdef ANIMATED
            Out.vAnimatedTexCoord = GetAnimatedTexcoord(v.vTexCoord);	
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
        struct RotateUVResult
        {
            float2 uv;
            float weight;
        };

        RotateUVResult CalculateRotateUV(float2 baseUV, float timeOffset)
        {
            RotateUVResult result;
            result.weight = 1.0f;

            float period = Offset.x / 10.0;
            
            float angle = 2.0 * 3.14159265359 * (Time + timeOffset) / period;
            float2 centered = baseUV - 0.5;
            float cosA = cos(angle);
            float sinA = sin(angle);
            result.uv.x = centered.x * cosA - centered.y * sinA + 0.5;
            result.uv.y = centered.x * sinA + centered.y * cosA + 0.5;
            
            return result;
        }

        float4 main( VS_OUTPUT v ) : PDX_COLOR
        {
            float4 OutColour = float4(0,0,0,0);
            float smoothEdge = 0.005f;

            RotateUVResult rotateResult = CalculateRotateUV(v.vTexCoord, 0.0f);
            float2 finalUV = rotateResult.uv;

            float weightCurrent = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * rotateResult.weight;
            if (weightCurrent > 0.f) {
                OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), weightCurrent);
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
            OutColor.a *= smoothstep(0.0, 0.01, v.vTexCoord);
        #endif
            
            OutColor *= Color;
            OutColor.a = saturate(OutColor.a);
            return OutColor;
        }
    ]]

    MainCode PixelShaderDisable
    [[
        struct RotateUVResult
        {
            float2 uv;
            float weight;
        };

        RotateUVResult CalculateRotateUV(float2 baseUV, float timeOffset)
        {
            RotateUVResult result;
            result.weight = 1.0f;
            float period = Offset.x / 10.0;
            float angle = 2.0 * 3.14159265359 * (Time + timeOffset) / period;
            float2 centered = baseUV - 0.5;
            float cosA = cos(angle);
            float sinA = sin(angle);
            result.uv.x = centered.x * cosA - centered.y * sinA + 0.5;
            result.uv.y = centered.x * sinA + centered.y * cosA + 0.5;
            return result;
        }

        float4 main( VS_OUTPUT v ) : PDX_COLOR
        {
            float4 OutColour = float4(0,0,0,0);
            float smoothEdge = 0.005f;

            RotateUVResult rotateResult = CalculateRotateUV(v.vTexCoord, 4.0f);
            float2 finalUV = rotateResult.uv;

            float weightCurrent = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * rotateResult.weight;
            if (weightCurrent > 0.f) {
                OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), weightCurrent);
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