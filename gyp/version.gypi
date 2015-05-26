{
  'targets': [
    {
      'target_name': 'version',
      'type': 'none',
      'hard_dependency': 1,
      'actions': [
        {
          'action_name': 'Build Version Header',
          'inputs': [
            '../scripts/build-version.py',
          ],
          'outputs': [
            '<(SHARED_INTERMEDIATE_DIR)/include/mbgl/util/version.hpp',
          ],
          'action': ['<@(_inputs)', '<(SHARED_INTERMEDIATE_DIR)', '<!@(echo ios-v$SOVER)', 'a400bc26a17721945a16878e61f2595530126b17'],
        }
      ],
      'direct_dependent_settings': {
        'sources': [
          '<(SHARED_INTERMEDIATE_DIR)/include/mbgl/util/version.hpp',
        ],
        'include_dirs': [
          '<(SHARED_INTERMEDIATE_DIR)/include',
        ]
      }
    },
  ]
}
