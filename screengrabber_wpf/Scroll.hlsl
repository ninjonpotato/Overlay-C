
Texture2D screenTexture : register(t0);
SamplerState screenSampler : register(s0);
cbuffer PositionConstants : register(b0)
{
    float2 Offset;
    float time;
    float speed;
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

    // Eltolás pixelben
    int offset = (int)(time * speed) % int(width);

    // Balról jobbra mozgás
    pixel.x = (pixel.x - offset + int(width)) % int(width);

    return screenTexture.Load(int3(pixel, 0));
}