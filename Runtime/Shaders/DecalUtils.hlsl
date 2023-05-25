
float LessOrEqual(float A, float B)
{
    return A <= B ? 1 : 0;
}

float Branch(float Predicate, float True, float False)
{
    return Predicate ? True : False;
}

float Remap(float In, float2 InMinMax, float2 OutMinMax)
{
    return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

float InverseLerp(float A, float B, float T)
{
    return (T - A)/(B - A);
}

float FadeNearBoundsZ(float fade, float zHS)
{
    float divide = (-1 / max(fade, 0.0001));
    return Branch(LessOrEqual(fade, 0), 1, saturate(divide * (abs(zHS) * 2) - divide));
}

float FadeByAngle(float min, float max, float3 normalOS)
{
    float3 divide =
        normalOS / float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                 length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                 length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z)));

    return 1 - saturate(InverseLerp(min, max, acos(dot(float3(0, 0, 1), normalize(divide)))));
}

float3 OffsetInViewSpace(float offset, float3 positionOS, float3 viewDirectionOS)
{
    return (offset * viewDirectionOS) + positionOS;
}

float2 DecalUV(float4 bounds, float flipu, float flipv, float2 IN)
{
    float u = Remap(IN[0], float2(0, 1), float2(Branch(flipu, bounds[2], bounds[0]), Branch(flipu, bounds[0], bounds[2])));
    float v = Remap(IN[1], float2(0, 1), float2(Branch(flipv, bounds[3], bounds[1]), Branch(flipv, bounds[1], bounds[3])));
    return float2(u, v);
}