//
//  Shaders.metal
//  Dreamline
//
//  Created by BeeDream on 3/21/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertex(const device packed_float3* vertex_array [[ buffer(0) ]],
                           unsigned int vid [[ vertex_id ]]) {
    return float4(vertex_array[vid], 1.0);
}

fragment half4 basic_fragment() {
    return half4(0.5, 0.5, 1.0, 1.0);
}
