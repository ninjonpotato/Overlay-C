
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
    //2 félre pontani a képernyőt
    int2 pixel = int2(position.xy);
    float4 color = screenTexture.Load(int3(pixel, 0));
        if(pixel.x < width/2) {
            pixel.x =  pixel.x + (int)(width/2);
             return screenTexture.Load(int3(pixel, 0));
         } else {
       pixel.x =  pixel.x - (int)(width/2);
             return screenTexture.Load(int3(pixel, 0));
      //   pixel.x = int(width) - 1 - pixel.x;    
         }
     
    

   
}
