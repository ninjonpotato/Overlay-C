
Texture2D screenTexture : register(t0);
SamplerState screenSampler : register(s0);
cbuffer PositionBuffer : register(b0) //a változóknak
{
    float2 offset; //vector2
    float2 padding;
};

float4 VSMain(uint vertexID : SV_VertexID) : SV_POSITION
{
    float2 positions[3] =
    {
        float2(-1.0, -1.0),
        float2(-1.0,  3.0),
        float2( 3.0, -1.0)
    };

    return float4(positions[vertexID], 0.0, 1.0);
}


float4 PSMain(float4 position : SV_POSITION) : SV_TARGET
{
    int2 pixel = int2(position.xy);

    uint width, height;
    screenTexture.GetDimensions(width, height);

    int radius = 15;

    float4 color = float4(0, 0, 0, 0);
    float totalWeight = 0;

    // 3x3 Gaussian kernel
    static const float weights[5] = {
        1.0, 1.0, 1.0,1.0,1.0
    };

    for (int x = -1; x <= 1; x++)
    {
        for (int y = -1; y <= 1; y++)
        {
            float weight =
                weights[x + 1] * weights[y + 1];

            int2 samplePixel = clamp(
                pixel + int2(x, y) * radius,
                int2(0, 0),
                int2(int(width) - 1, int(height) - 1)
            );

            color += screenTexture.Load(
                int3(samplePixel, 0)
            ) * weight;

            totalWeight += weight;
        }
    }

    return color / totalWeight;
}