{
  'includes': [
    '../gyp/common.gypi',
  ],
  'targets': [
    { 'target_name': 'mbgl-render',
      'product_name': 'mbgl-render',
      'type': 'executable',

      'dependencies': [
        '../mbgl.gyp:mbgl',
      ],

      'include_dirs': [
        '../src',
      ],

      'sources': [
        './render.cpp',
        '../platform/default/default_styles.cpp',
        '../platform/default/default_styles.hpp',
      ],

      'variables' : {
        'cflags_cc': [
          '<@(glfw3_cflags)',
          '<@(uv_cflags)',
          '<@(boost_cflags)',
        ],
        'ldflags': [
          '<@(glfw3_ldflags)',
          '<@(uv_ldflags)',
        ],
        'libraries': [
          '<@(glfw3_static_libs)',
          '<@(uv_static_libs)',
          '<@(boost_program_options_static_libs)',
          '-lboost_filesystem',
          '-lboost_system'
        ],
      },

      'conditions': [
        ['OS == "mac"', {
          'libraries': [ '<@(libraries)' ],
          'xcode_settings': {
            'OTHER_CPLUSPLUSFLAGS': [ '<@(cflags_cc)' ],
            'OTHER_LDFLAGS': [ '<@(ldflags)' ],
          }
        }, {
          'cflags_cc': [ '<@(cflags_cc)' ],
          'libraries': [ '<@(libraries)', '<@(ldflags)' ],
        }]
      ],
    },
  ],
}
