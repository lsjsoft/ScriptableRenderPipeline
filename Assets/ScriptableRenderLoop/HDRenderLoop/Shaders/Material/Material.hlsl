#ifndef UNITY_MATERIAL_INCLUDED
#define UNITY_MATERIAL_INCLUDED

#include "Packing.hlsl"
#include "BSDF.hlsl"
#include "Debug.hlsl"
#include "GeometricTools.hlsl"
#include "CommonMaterial.hlsl"
#include "EntityLighting.hlsl"

//-----------------------------------------------------------------------------
// BuiltinData
//-----------------------------------------------------------------------------

#include "Builtin/BuiltinData.hlsl"

//-----------------------------------------------------------------------------
// Material definition
//-----------------------------------------------------------------------------

// Here we include all the different lighting model supported by the renderloop based on define done in .shader
#ifdef UNITY_MATERIAL_LIT
#include "Lit/Lit.hlsl"
#elif defined(UNITY_MATERIAL_UNLIT)
#include "Unlit/Unlit.hlsl"
#endif

//-----------------------------------------------------------------------------
// Define for GBuffer management
//-----------------------------------------------------------------------------

#ifdef GBUFFERMATERIAL_COUNT

#if GBUFFERMATERIAL_COUNT == 2

#define OUTPUT_GBUFFER(NAME)                            \
        out float4 MERGE_NAME(NAME, 0) : SV_Target0,    \
        out float4 MERGE_NAME(NAME, 1) : SV_Target1

#define DECLARE_GBUFFER_TEXTURE(NAME)   \
        TEXTURE2D(MERGE_NAME(NAME, 0));  \
        TEXTURE2D(MERGE_NAME(NAME, 1));

#define FETCH_GBUFFER(NAME, TEX, UV)                                        \
        float4 MERGE_NAME(NAME, 0) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 0), uint3(UV, 0)); \
        float4 MERGE_NAME(NAME, 1) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 1), uint3(UV, 0));

#define ENCODE_INTO_GBUFFER(SURFACE_DATA, NAME) EncodeIntoGBuffer(SURFACE_DATA, MERGE_NAME(NAME,0), MERGE_NAME(NAME,1), MERGE_NAME(NAME,2))
#define DECODE_FROM_GBUFFER(NAME) DecodeFromGBuffer(MERGE_NAME(NAME,0), MERGE_NAME(NAME,1), MERGE_NAME(NAME,2))

#define GBUFFER_BAKE_LIGHTING_NAME(NAME) MERGE_NAME(NAME, 2)
#define GBUFFER_BAKE_LIGHTING_TARGET(TARGET) MERGE_NAME(TARGET, 2)
#ifdef VELOCITY_IN_GBUFFER
#define GBUFFER_VELOCITY_NAME(NAME) MERGE_NAME(NAME, 3)
#define GBUFFER_VELOCITY_TARGET(TARGET) MERGE_NAME(TARGET, 3)
#endif

#elif GBUFFERMATERIAL_COUNT == 3

#define OUTPUT_GBUFFER(NAME)                            \
        out float4 MERGE_NAME(NAME, 0) : SV_Target0,    \
        out float4 MERGE_NAME(NAME, 1) : SV_Target1,    \
        out float4 MERGE_NAME(NAME, 2) : SV_Target2

#define DECLARE_GBUFFER_TEXTURE(NAME)   \
        TEXTURE2D(MERGE_NAME(NAME, 0));  \
        TEXTURE2D(MERGE_NAME(NAME, 1));  \
        TEXTURE2D(MERGE_NAME(NAME, 2));

#define FETCH_GBUFFER(NAME, TEX, UV)                                        \
        float4 MERGE_NAME(NAME, 0) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 0), uint3(UV, 0)); \
        float4 MERGE_NAME(NAME, 1) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 1), uint3(UV, 0)); \
        float4 MERGE_NAME(NAME, 2) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 2), uint3(UV, 0));

#define ENCODE_INTO_GBUFFER(SURFACE_DATA, NAME) EncodeIntoGBuffer(SURFACE_DATA, MERGE_NAME(NAME,0), MERGE_NAME(NAME,1), MERGE_NAME(NAME,2))
#define DECODE_FROM_GBUFFER(NAME) DecodeFromGBuffer(MERGE_NAME(NAME,0), MERGE_NAME(NAME,1), MERGE_NAME(NAME,2))

#define GBUFFER_BAKE_LIGHTING_NAME(NAME) MERGE_NAME(NAME, 3)
#define GBUFFER_BAKE_LIGHTING_TARGET(TARGET) MERGE_NAME(TARGET, 3)
#ifdef VELOCITY_IN_GBUFFER
#define GBUFFER_VELOCITY_NAME(NAME) MERGE_NAME(NAME, 4)
#define GBUFFER_VELOCITY_TARGET(TARGET) MERGE_NAME(TARGET, 4)
#endif

#elif GBUFFERMATERIAL_COUNT == 4

#define OUTPUT_GBUFFER(NAME)                            \
        out float4 MERGE_NAME(NAME, 0) : SV_Target0,    \
        out float4 MERGE_NAME(NAME, 1) : SV_Target1,    \
        out float4 MERGE_NAME(NAME, 2) : SV_Target2,    \
        out float4 MERGE_NAME(NAME, 3) : SV_Target3

#define DECLARE_GBUFFER_TEXTURE(NAME)   \
        TEXTURE2D(MERGE_NAME(NAME, 0));  \
        TEXTURE2D(MERGE_NAME(NAME, 1));  \
        TEXTURE2D(MERGE_NAME(NAME, 2));  \
        TEXTURE2D(MERGE_NAME(NAME, 3));

#define FETCH_GBUFFER(NAME, TEX, UV)                                        \
        float4 MERGE_NAME(NAME, 0) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 0), uint3(UV, 0)); \
        float4 MERGE_NAME(NAME, 1) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 1), uint3(UV, 0)); \
        float4 MERGE_NAME(NAME, 2) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 2), uint3(UV, 0)); \
        float4 MERGE_NAME(NAME, 3) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 3), uint3(UV, 0));

#define ENCODE_INTO_GBUFFER(SURFACE_DATA, NAME) EncodeIntoGBuffer(SURFACE_DATA, MERGE_NAME(NAME, 0), MERGE_NAME(NAME, 1), MERGE_NAME(NAME, 2), MERGE_NAME(NAME, 3))
#define DECODE_FROM_GBUFFER(NAME) DecodeFromGBuffer(MERGE_NAME(NAME, 0), MERGE_NAME(NAME, 1), MERGE_NAME(NAME, 2), MERGE_NAME(NAME, 3))

#define GBUFFER_BAKE_LIGHTING_NAME(NAME) MERGE_NAME(NAME, 4)
#define GBUFFER_BAKE_LIGHTING_TARGET(TARGET) MERGE_NAME(TARGET, 4)
#ifdef VELOCITY_IN_GBUFFER
#define GBUFFER_BAKE_LIGHTING_NAME(NAME) MERGE_NAME(NAME, 5)
#define GBUFFER_BAKE_LIGHTING_TARGET(TARGET) MERGE_NAME(TARGET, 5)
#endif

#elif GBUFFERMATERIAL_COUNT == 5

#define OUTPUT_GBUFFER(NAME)                            \
        out float4 MERGE_NAME(NAME, 0) : SV_Target0,    \
        out float4 MERGE_NAME(NAME, 1) : SV_Target1,    \
        out float4 MERGE_NAME(NAME, 2) : SV_Target2,    \
        out float4 MERGE_NAME(NAME, 3) : SV_Target3,    \
        out float4 MERGE_NAME(NAME, 4) : SV_Target4

#define DECLARE_GBUFFER_TEXTURE(NAME)   \
        TEXTURE2D(MERGE_NAME(NAME, 0));  \
        TEXTURE2D(MERGE_NAME(NAME, 1));  \
        TEXTURE2D(MERGE_NAME(NAME, 2));  \
        TEXTURE2D(MERGE_NAME(NAME, 3));  \
        TEXTURE2D(MERGE_NAME(NAME, 4));

#define FETCH_GBUFFER(NAME, TEX, UV)                                        \
        float4 MERGE_NAME(NAME, 0) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 0), uint3(UV, 0)); \
        float4 MERGE_NAME(NAME, 1) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 1), uint3(UV, 0)); \
        float4 MERGE_NAME(NAME, 2) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 2), uint3(UV, 0)); \
        float4 MERGE_NAME(NAME, 3) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 3), uint3(UV, 0)); \
        float4 MERGE_NAME(NAME, 4) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 4), uint3(UV, 0));

#define ENCODE_INTO_GBUFFER(SURFACE_DATA, NAME) EncodeIntoGBuffer(SURFACE_DATA, MERGE_NAME(NAME, 0), MERGE_NAME(NAME, 1), MERGE_NAME(NAME, 2), MERGE_NAME(NAME, 3), MERGE_NAME(NAME, 4))
#define DECODE_FROM_GBUFFER(NAME) DecodeFromGBuffer(MERGE_NAME(NAME, 0), MERGE_NAME(NAME, 1), MERGE_NAME(NAME, 2), MERGE_NAME(NAME, 3), MERGE_NAME(NAME, 4))

#define GBUFFER_BAKE_LIGHTING_NAME(NAME) MERGE_NAME(NAME, 5)
#define GBUFFER_BAKE_LIGHTING_TARGET(TARGET) MERGE_NAME(TARGET, 5)
#ifdef VELOCITY_IN_GBUFFER
#define GBUFFER_BAKE_LIGHTING_NAME(NAME) MERGE_NAME(NAME, 6)
#define GBUFFER_BAKE_LIGHTING_TARGET(TARGET) MERGE_NAME(TARGET, 6)
#endif

#endif // #if GBUFFERMATERIAL_COUNT == 3

// Generic whatever the number of GBuffer
#define OUTPUT_GBUFFER_BAKE_LIGHTING(NAME) out float4 GBUFFER_BAKE_LIGHTING_NAME(NAME) : GBUFFER_BAKE_LIGHTING_TARGET(SV_Target)
#define DECLARE_GBUFFER_BAKE_LIGHTING(NAME) TEXTURE2D(GBUFFER_BAKE_LIGHTING_NAME(NAME));
#define ENCODE_BAKE_LIGHTING_INTO_GBUFFER(BAKE_DIFFUSE_LIGHTING, NAME) EncodeBakedDiffuseLigthingIntoGBuffer(BAKE_DIFFUSE_LIGHTING, GBUFFER_BAKE_LIGHTING_NAME(NAME))
#define FETCH_BAKE_LIGHTING_GBUFFER(NAME, TEX, UV) float4 GBUFFER_BAKE_LIGHTING_NAME(NAME) = LOAD_TEXTURE2D(GBUFFER_BAKE_LIGHTING_NAME(TEX), uint3(UV, 0));
#define DECODE_BAKE_LIGHTING_FROM_GBUFFER(NAME) DecodeBakedDiffuseLigthingFromGBuffer(GBUFFER_BAKE_LIGHTING_NAME(NAME))

#ifdef VELOCITY_IN_GBUFFER
#define OUTPUT_GBUFFER_VELOCITY(NAME) out float4 GBUFFER_VELOCITY_NAME(NAME) : GBUFFER_VELOCITY_TARGET(SV_Target)
#define DECLARE_GBUFFER_VELOCITY_TEXTURE(NAME) TEXTURE2D(GBUFFER_VELOCITY_NAME(NAME));
#define ENCODE_VELOCITY_INTO_GBUFFER(VELOCITY, NAME) EncodeVelocity(VELOCITY, GBUFFER_VELOCITY_NAME(NAME))
#endif

#endif // #ifdef GBUFFERMATERIAL_COUNT

#endif // UNITY_MATERIAL_INCLUDED
