
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
    uint width, height;
    screenTexture.GetDimensions(width, height);

    int2 pixel = int2(position.xy);

    int2 rotatedPixel = int2(
        pixel.x,
        int(height) - 1 - pixel.y
    );

    float4 color = screenTexture.Load(int3(rotatedPixel, 0));

    return color;
}
