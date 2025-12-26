Includes = {
    "buttonstate.fxh",  // 补充缺失的逗号，语法修正
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
            AddressU = "Repeat"  // X轴循环滚动需开启Repeat
            AddressV = "Clamp"   // 【修改1】数字垂直滚动禁用Repeat，避免视觉循环
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
        // 兼容老着色器：定义结构体替代out参数
        struct SlideUVResult
        {
            float2 uv;
            float weight;
        };

        // 向左循环滑动计算工具函数（参数：图片数、停留时间、滚动时间）
        SlideUVResult CalculateCycleSlideUV(float2 baseUV, float timeOffset)
        {
            SlideUVResult result;
            result.weight = 1.0f;

            // 可配置常量（直接修改此处调整效果）
            float NUM_IMAGES = 6.0f;          // 图片数量
            float STAY_DURATION = 4.0f;       // 每张图停留时间
            float SLIDE_DURATION = 0.8f;      // 滚动过渡时间
            float SLIDE_OFFSET_SCALE = 1.0f / NUM_IMAGES;  // 修改  每张图占X轴1/NUM_IMAGES宽度，避免偏移过量

            // 计算总循环周期：(停留+滚动)×图片数
            float TOTAL_CYCLE = NUM_IMAGES * (STAY_DURATION + SLIDE_DURATION);
            // 当前循环进度（0~1），加入相位偏移避免多数位同步
            float cycleProgress = frac((Time + timeOffset) / TOTAL_CYCLE);
            // 单张图的时间占比（停留+滚动）
            float singleSegmentTime = STAY_DURATION + SLIDE_DURATION;
            float singleSegmentRatio = singleSegmentTime / TOTAL_CYCLE;

            // 计算当前显示的图片索引
            int currentImg = floor(cycleProgress / singleSegmentRatio);
            // 下一张图片索引（循环）
            int nextImg = (currentImg + 1) % int(NUM_IMAGES);
            // 单张图内的进度（0~1，包含停留和滚动）
            float inSegProgress = (cycleProgress - currentImg * singleSegmentRatio) / singleSegmentRatio;

            float smoothProgress = 0.0f;
            // 仅在滚动阶段计算平滑进度（停留阶段进度为0，图片静止）
            if (inSegProgress > STAY_DURATION / singleSegmentTime)
            {
                // 滚动阶段的相对进度（0~1）
                float slideInSegProgress = (inSegProgress - STAY_DURATION / singleSegmentTime) / (SLIDE_DURATION / singleSegmentTime);
                smoothProgress = smoothstep(0.0f, 1.0f, slideInSegProgress);
            }

            // 向左滚动的X轴偏移（UV.x增加→纹理视觉左移，符号为+正确）
            float xOffset = smoothProgress * SLIDE_OFFSET_SCALE;
            result.uv = baseUV;
            // 叠加当前图片的基础偏移 + 滚动偏移
            result.uv.x += (currentImg * SLIDE_OFFSET_SCALE) + xOffset;
            // 循环纹理坐标，确保超出部分循环显示
            result.uv.x = frac(result.uv.x);

            return result;
        }

        float4 main( VS_OUTPUT v ) : PDX_COLOR
        {
            float vTime = Time - AnimationTime;
            float value = floor((Offset.x) * 10.f) + 1.f;
            float commaVal = floor(value / 1000000.f);
            float endVal = floor(value / 1000.f) - (commaVal * 1000.f);
            float startVal = value - (endVal * 1000.f) - (commaVal * 1000000.f);
            
            float animProgress = v.vAnimProgress;
            bool isAnimFinished = (animProgress >= 1.0f);
            
            // 拆分起始值和目标值的各位
            float startHun = clamp(floor(startVal / 100.f), 0.0f, 9.0f);
            float startTen = clamp(floor((startVal - startHun * 100.f) / 10.f), 0.0f, 9.0f);
            float startOne = clamp(floor(startVal - startHun * 100.f - startTen * 10.f), 0.0f, 9.0f);
            
            float endHun = clamp(floor(endVal / 100.f), 0.0f, 9.0f);
            float endTen = clamp(floor((endVal - endHun * 100.f) / 10.f), 0.0f, 9.0f);
            float endOne = clamp(floor(endVal - endHun * 100.f - endTen * 10.f), 0.0f, 9.0f);
            
            float smoothEdge = 0.005f;
            float4 OutColour = float4(0,0,0,0);
            
            // 2. 百位独立动画逻辑（向左循环滚动）
            {
                float currentNum = startHun;
                float nextNum = startHun;
                float currentWeight = 1.0f;
                float nextWeight = 0.0f;
                float2 texUV = float2(v.vTexCoord.x, v.vTexCoord.y);
                
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
                        texUV.y += scrollOffset * 0.1f;  // 【修改3】数字占V轴0.1高度，偏移比例修正
                    } else {
                        currentNum = (startHun - rolledTimes + 10.0f) % 10.0f;
                        nextNum = (currentNum - 1.0f + 10.0f) % 10.0f;
                        texUV.y -= scrollOffset * 0.1f;  // 【修改3】数字占V轴0.1高度，偏移比例修正
                    }
                    
                    currentWeight = 1.0f - currentRollProgress;
                    nextWeight = currentRollProgress;
                }
                // 动画结束后：向左循环滚动（百位相位偏移0）
                else if (isAnimFinished) {
                    currentNum = endHun;
                    SlideUVResult slideResult = CalculateCycleSlideUV(float2(v.vTexCoord.x, v.vTexCoord.y), 0.0f);
                    texUV = slideResult.uv;
                    currentWeight = slideResult.weight;
                }
                
                // 百位整宽显示
                float weightCurrent = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * currentWeight;
                if (weightCurrent > 0.f) {
                    float xPoint = 0.1f * currentNum;
                    float2 finalUV = float2(xPoint + texUV.x, texUV.y);
                    OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), weightCurrent);
                }
                
                if (isHunAnim && !isAnimFinished && nextWeight > 0.f) {
                    float weightNext = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * nextWeight;
                    if (weightNext > 0.f) {
                        float xPoint = 0.1f * nextNum;
                        float2 finalUV;
                        if (isHunUp) {
                            finalUV = float2(xPoint + texUV.x, texUV.y - 0.1f);  // 【修改4】下一个数字的V轴偏移修正为0.1
                        } else {
                            finalUV = float2(xPoint + texUV.x, texUV.y + 0.1f);  // 【修改4】下一个数字的V轴偏移修正为0.1
                        }
                        OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), weightNext);
                    }
                }
            }
            
            // 3. 十位独立动画逻辑（向左循环滚动）
            {
                float currentNum = startTen;
                float nextNum = startTen;
                float currentWeight = 1.0f;
                float nextWeight = 0.0f;
                float2 texUV = float2(v.vTexCoord.x, v.vTexCoord.y);
                
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
                        texUV.y += scrollOffset * 0.1f;  // 【修改3】数字占V轴0.1高度，偏移比例修正
                    } else {
                        currentNum = (startTen - rolledTimes + 10.0f) % 10.0f;
                        nextNum = (currentNum - 1.0f + 10.0f) % 10.0f;
                        texUV.y -= scrollOffset * 0.1f;  // 【修改3】数字占V轴0.1高度，偏移比例修正
                    }
                    
                    currentWeight = 1.0f - currentRollProgress;
                    nextWeight = currentRollProgress;
                }
                // 动画结束后：向左循环滚动（十位相位偏移2.0）
                else if (isAnimFinished) {
                    currentNum = endTen;
                    SlideUVResult slideResult = CalculateCycleSlideUV(float2(v.vTexCoord.x, v.vTexCoord.y), 2.0f);
                    texUV = slideResult.uv;
                    currentWeight = slideResult.weight;
                }
                
                // 十位整宽显示
                float weightCurrent = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * currentWeight;
                if (weightCurrent > 0.f) {
                    float xPoint = 0.1f * currentNum;
                    float2 finalUV = float2(xPoint + texUV.x, texUV.y);
                    OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), weightCurrent);
                }
                
                if (isTenAnim && !isAnimFinished && nextWeight > 0.f) {
                    float weightNext = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * nextWeight;
                    if (weightNext > 0.f) {
                        float xPoint = 0.1f * nextNum;
                        float2 finalUV;
                        if (isTenUp) {
                            finalUV = float2(xPoint + texUV.x, texUV.y - 0.1f);  // 【修改4】下一个数字的V轴偏移修正为0.1
                        } else {
                            finalUV = float2(xPoint + texUV.x, texUV.y + 0.1f);  // 【修改4】下一个数字的V轴偏移修正为0.1
                        }
                        OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), nextWeight);
                    }
                }
            }
            
            // 4. 个位独立动画逻辑（向左循环滚动）
            {
                float currentNum = startOne;
                float nextNum = startOne;
                float currentWeight = 1.0f;
                float nextWeight = 0.0f;
                float2 texUV = float2(v.vTexCoord.x, v.vTexCoord.y);
                
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
                        texUV.y += scrollOffset * 0.1f;  // 【修改3】数字占V轴0.1高度，偏移比例修正
                    } else {
                        currentNum = (startOne - rolledTimes + 10.0f) % 10.0f;
                        nextNum = (currentNum - 1.0f + 10.0f) % 10.0f;
                        texUV.y -= scrollOffset * 0.1f;  // 【修改3】数字占V轴0.1高度，偏移比例修正
                    }
                    
                    currentWeight = 1.0f - currentRollProgress;
                    nextWeight = currentRollProgress;
                }
                // 动画结束后：向左循环滚动（个位相位偏移4.0）
                else if (isAnimFinished) {
                    currentNum = endOne;
                    SlideUVResult slideResult = CalculateCycleSlideUV(float2(v.vTexCoord.x, v.vTexCoord.y), 4.0f);
                    texUV = slideResult.uv;
                    currentWeight = slideResult.weight;
                }
                
                // 个位整宽显示
                float weightCurrent = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * currentWeight;
                if (weightCurrent > 0.f) {
                    float xPoint = 0.1f * currentNum;
                    float2 finalUV = float2(xPoint + texUV.x, texUV.y);
                    OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), weightCurrent);
                }
                
                if (isOneAnim && !isAnimFinished && nextWeight > 0.f) {
                    float weightNext = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * nextWeight;
                    if (weightNext > 0.f) {
                        float xPoint = 0.1f * nextNum;
                        float2 finalUV;
                        if (isOneUp) {
                            finalUV = float2(xPoint + texUV.x, texUV.y - 0.1f);  // 【修改4】下一个数字的V轴偏移修正为0.1
                        } else {
                            finalUV = float2(xPoint + texUV.x, texUV.y + 0.1f);  // 【修改4】下一个数字的V轴偏移修正为0.1
                        }
                        OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), nextWeight);
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
        // 兼容老着色器：定义结构体替代out参数
        struct SlideUVResult
        {
            float2 uv;
            float weight;
        };

        // 向左循环滑动计算工具函数（参数：图片数、停留时间、滚动时间）
        SlideUVResult CalculateCycleSlideUV(float2 baseUV, float timeOffset)
        {
            SlideUVResult result;
            result.weight = 1.0f;

            // 可配置常量（直接修改此处调整效果）
            float NUM_IMAGES = 6.0f;          // 图片数量
            float STAY_DURATION = 4.0f;       // 每张图停留时间
            float SLIDE_DURATION = 0.8f;      // 滚动过渡时间
            float SLIDE_OFFSET_SCALE = 1.0f / NUM_IMAGES;  // 修改  每张图占X轴1/NUM_IMAGES宽度，避免偏移过量

            // 计算总循环周期：(停留+滚动)×图片数
            float TOTAL_CYCLE = NUM_IMAGES * (STAY_DURATION + SLIDE_DURATION);
            // 当前循环进度（0~1），加入相位偏移避免多数位同步
            float cycleProgress = frac((Time + timeOffset) / TOTAL_CYCLE);
            // 单张图的时间占比（停留+滚动）
            float singleSegmentTime = STAY_DURATION + SLIDE_DURATION;
            float singleSegmentRatio = singleSegmentTime / TOTAL_CYCLE;

            // 计算当前显示的图片索引
            int currentImg = floor(cycleProgress / singleSegmentRatio);
            // 下一张图片索引（循环）
            int nextImg = (currentImg + 1) % int(NUM_IMAGES);
            // 单张图内的进度（0~1，包含停留和滚动）
            float inSegProgress = (cycleProgress - currentImg * singleSegmentRatio) / singleSegmentRatio;

            float smoothProgress = 0.0f;
            // 仅在滚动阶段计算平滑进度（停留阶段进度为0，图片静止）
            if (inSegProgress > STAY_DURATION / singleSegmentTime)
            {
                // 滚动阶段的相对进度（0~1）
                float slideInSegProgress = (inSegProgress - STAY_DURATION / singleSegmentTime) / (SLIDE_DURATION / singleSegmentTime);
                smoothProgress = smoothstep(0.0f, 1.0f, slideInSegProgress);
            }

            // 向左滚动的X轴偏移（UV.x增加→纹理视觉左移，符号为+正确）
            float xOffset = smoothProgress * SLIDE_OFFSET_SCALE;
            result.uv = baseUV;
            // 叠加当前图片的基础偏移 + 滚动偏移
            result.uv.x += (currentImg * SLIDE_OFFSET_SCALE) + xOffset;
            // 循环纹理坐标，确保超出部分循环显示
            result.uv.x = frac(result.uv.x);

            return result;
        }

        float4 main( VS_OUTPUT v ) : PDX_COLOR
        {
            float vTime = Time - AnimationTime;
            float value = floor((Offset.x) * 10.f) + 1.f;
            float commaVal = floor(value / 1000000.f);
            float endVal = floor(value / 1000.f) - (commaVal * 1000.f);
            float startVal = value - (endVal * 1000.f) - (commaVal * 1000000.f);
            
            float animProgress = v.vAnimProgress;
            bool isAnimFinished = (animProgress >= 1.0f);
            
            // 拆分起始值和目标值的各位
            float startHun = clamp(floor(startVal / 100.f), 0.0f, 9.0f);
            float startTen = clamp(floor((startVal - startHun * 100.f) / 10.f), 0.0f, 9.0f);
            float startOne = clamp(floor(startVal - startHun * 100.f - startTen * 10.f), 0.0f, 9.0f);
            
            float endHun = clamp(floor(endVal / 100.f), 0.0f, 9.0f);
            float endTen = clamp(floor((endVal - endHun * 100.f) / 10.f), 0.0f, 9.0f);
            float endOne = clamp(floor(endVal - endHun * 100.f - endTen * 10.f), 0.0f, 9.0f);
            
            float smoothEdge = 0.005f;
            float4 OutColour = float4(0,0,0,0);
            
            // 2. 百位独立动画逻辑
            {
                float currentNum = startHun;
                float nextNum = startHun;
                float currentWeight = 1.0f;
                float nextWeight = 0.0f;
                float2 texUV = float2(v.vTexCoord.x, v.vTexCoord.y);
                
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
                        texUV.y += scrollOffset * 0.1f;  // 【修改3】数字占V轴0.1高度，偏移比例修正
                    } else {
                        currentNum = (startHun - rolledTimes + 10.0f) % 10.0f;
                        nextNum = (currentNum - 1.0f + 10.0f) % 10.0f;
                        texUV.y -= scrollOffset * 0.1f;  // 【修改3】数字占V轴0.1高度，偏移比例修正
                    }
                    
                    currentWeight = 1.0f - currentRollProgress;
                    nextWeight = currentRollProgress;
                }
                else if (isAnimFinished) {
                    currentNum = endHun;
                    SlideUVResult slideResult = CalculateCycleSlideUV(float2(v.vTexCoord.x, v.vTexCoord.y), 0.0f);
                    texUV = slideResult.uv;
                    currentWeight = slideResult.weight;
                }
                
                float weightCurrent = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * currentWeight;
                if (weightCurrent > 0.f) {
                    float xPoint = 0.1f * currentNum;
                    float2 finalUV = float2(xPoint + texUV.x, texUV.y);
                    OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), weightCurrent);
                }
                
                if (isHunAnim && !isAnimFinished && nextWeight > 0.f) {
                    float weightNext = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * nextWeight;
                    if (weightNext > 0.f) {
                        float xPoint = 0.1f * nextNum;
                        float2 finalUV = isHunUp ? 
                            float2(xPoint + texUV.x, texUV.y - 0.1f) :  // 【修改4】下一个数字的V轴偏移修正为0.1
                            float2(xPoint + texUV.x, texUV.y + 0.1f);  // 【修改4】下一个数字的V轴偏移修正为0.1
                        OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), nextWeight);
                    }
                }
            }
            
            // 3. 十位独立动画逻辑
            {
                float currentNum = startTen;
                float nextNum = startTen;
                float currentWeight = 1.0f;
                float nextWeight = 0.0f;
                float2 texUV = float2(v.vTexCoord.x, v.vTexCoord.y);
                
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
                        texUV.y += scrollOffset * 0.1f;  // 【修改3】数字占V轴0.1高度，偏移比例修正
                    } else {
                        currentNum = (startTen - rolledTimes + 10.0f) % 10.0f;
                        nextNum = (currentNum - 1.0f + 10.0f) % 10.0f;
                        texUV.y -= scrollOffset * 0.1f;  // 【修改3】数字占V轴0.1高度，偏移比例修正
                    }
                    
                    currentWeight = 1.0f - currentRollProgress;
                    nextWeight = currentRollProgress;
                }
                else if (isAnimFinished) {
                    currentNum = endTen;
                    SlideUVResult slideResult = CalculateCycleSlideUV(float2(v.vTexCoord.x, v.vTexCoord.y), 2.0f);
                    texUV = slideResult.uv;
                    currentWeight = slideResult.weight;
                }
                
                float weightCurrent = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * currentWeight;
                if (weightCurrent > 0.f) {
                    float xPoint = 0.1f * currentNum;
                    float2 finalUV = float2(xPoint + texUV.x, texUV.y);
                    OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), weightCurrent);
                }
                
                if (isTenAnim && !isAnimFinished && nextWeight > 0.f) {
                    float weightNext = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * nextWeight;
                    if (weightNext > 0.f) {
                        float xPoint = 0.1f * nextNum;
                        float2 finalUV = isTenUp ? 
                            float2(xPoint + texUV.x, texUV.y - 0.1f) :  // 【修改4】下一个数字的V轴偏移修正为0.1
                            float2(xPoint + texUV.x, texUV.y + 0.1f);  // 【修改4】下一个数字的V轴偏移修正为0.1
                        OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), nextWeight);
                    }
                }
            }
            
            // 4. 个位独立动画逻辑
            {
                float currentNum = startOne;
                float nextNum = startOne;
                float currentWeight = 1.0f;
                float nextWeight = 0.0f;
                float2 texUV = float2(v.vTexCoord.x, v.vTexCoord.y);
                
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
                        texUV.y += scrollOffset * 0.1f;  // 【修改3】数字占V轴0.1高度，偏移比例修正
                    } else {
                        currentNum = (startOne - rolledTimes + 10.0f) % 10.0f;
                        nextNum = (currentNum - 1.0f + 10.0f) % 10.0f;
                        texUV.y -= scrollOffset * 0.1f;  // 【修改3】数字占V轴0.1高度，偏移比例修正
                    }
                    
                    currentWeight = 1.0f - currentRollProgress;
                    nextWeight = currentRollProgress;
                }
                else if (isAnimFinished) {
                    currentNum = endOne;
                    SlideUVResult slideResult = CalculateCycleSlideUV(float2(v.vTexCoord.x, v.vTexCoord.y), 4.0f);
                    texUV = slideResult.uv;
                    currentWeight = slideResult.weight;
                }
                
                float weightCurrent = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * currentWeight;
                if (weightCurrent > 0.f) {
                    float xPoint = 0.1f * currentNum;
                    float2 finalUV = float2(xPoint + texUV.x, texUV.y);
                    OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), weightCurrent);
                }
                
                if (isOneAnim && !isAnimFinished && nextWeight > 0.f) {
                    float weightNext = smoothstep(-smoothEdge, smoothEdge, 1.0f - v.vTexCoord.x) * nextWeight;
                    if (weightNext > 0.f) {
                        float xPoint = 0.1f * nextNum;
                        float2 finalUV = isOneUp ? 
                            float2(xPoint + texUV.x, texUV.y - 0.1f) :  // 【修改4】下一个数字的V轴偏移修正为0.1
                            float2(xPoint + texUV.x, texUV.y + 0.1f);  // 【修改4】下一个数字的V轴偏移修正为0.1
                        OutColour = lerp(OutColour, tex2D(MapTexture, finalUV), nextWeight);
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