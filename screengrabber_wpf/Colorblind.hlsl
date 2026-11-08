
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
    float3 targetColors[] =
    {
      //   float3(0, 0, 0) / 255.0,
        float3(92, 255, 51) / 255.0, //4
        float3(52, 255, 194) / 255.0, //8
        float3(49, 134, 255) / 255.0, //16
        float3(153, 51, 255) / 255.0, //32
        float3(255, 51, 173) / 255.0, //64
   //     float3(127, 25, 83) / 255.0, //64
        float3(255, 112, 51) / 255.0, //128
        float3(215, 255, 51) / 255.0, //256
        float3(43, 217, 60) / 255.0, //512
        float3(51, 255, 255) / 255.0, //1024
        float3(51, 71, 255) / 255.0, //2048
        float3(255, 255, 51) / 255.0,
        float3(255, 51, 51) / 255.0,
        float3(51, 255, 71) / 255.0
       
    };
        float tolerance = 0.55;

    uint count = targetColors.Length;
    uint stride;

    float2 rectPos = float2(710, 320);
    float2 rectSize = float2(1150, 1060);
      // Ha a kereten kívül van, nem alkalmazunk effektet
    if (position.x < rectPos.x ||
        position.y < rectPos.y ||
        position.x >= rectPos.x + rectSize.x ||
        position.y >= rectPos.y + rectSize.y)
    {
        return color;
    }
  //  return float4(1, 1, 1, 1);

    for (uint i = 0; i < count; i++)
    {
        float3 diff = abs(color.rgb - targetColors[i]);

        if (all(diff <= tolerance))
        {
            return float4(0, 0, 0, 1);
        }
    }
   float gray = dot(color.rgb, float3(0.299, 0.587, 0.114));
    return float4(gray,gray,gray,0);
    return color;
}
