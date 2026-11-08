
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
    float4 color = screenTexture.Load(int3(pixel, 0));

  
    float2 rectPos = float2(710, 0);
    float2 rectSize = float2(1150, 1360);
      // Ha a kereten kívül van, nem alkalmazunk effektet
    if (position.x < rectPos.x ||
        position.y < rectPos.y ||
        position.x >= rectPos.x + rectSize.x ||
        position.y >= rectPos.y + rectSize.y)
    {
        return color;
    }
  //  return float4(1, 1, 1, 1);
   float3 diff = abs(color.rgb - float3(0,0,0));

   if (all(diff >= 0.13))
        {
            return float4(1, 1, 1, 1);
        }
    int radius = 3;

for (int x = -radius; x <= radius; x++)
{
    for (int y = -radius; y <= radius; y++)
    {
        int2 neighborPixel = pixel + int2(x, y);

        // Textúrahatárok ellenőrzése
        neighborPixel = clamp(
            neighborPixel,
            int2(0, 0),
            int2(int(width) - 1, int(height) - 1)
        );

        float3 neighbor = screenTexture.Load(
            int3(neighborPixel, 0)
        ).rgb;

        float3 neighborDiff = abs(neighbor - float3(0, 0, 0));

        if (all(neighborDiff >= 0.13))
        {
            return float4(1, 1, 1, 1);
        }
    }
}

float gray = dot(color.rgb, float3(0.299, 0.587, 0.114));
return float4(gray, gray, gray, 0);
}
