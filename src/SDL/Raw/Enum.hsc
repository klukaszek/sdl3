{-# LANGUAGE CPP #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE TypeSynonymInstances #-}

#if MIN_VERSION_base(4,11,0)
-- OPTIONS_GHC -fno-warn-missing-pattern-synonym-signatures #
#endif
-- OPTIONS_GHC -fno-warn-missing-signatures #

module SDL.Raw.Enum (
  -- * Enumerations

  -- ** Audio Format
  AudioFormat,
  pattern SDL_AUDIO_U8,
  pattern SDL_AUDIO_S8,
  pattern SDL_AUDIO_S16LE, 
  pattern SDL_AUDIO_S16BE, 
  pattern SDL_AUDIO_S16, 
  pattern SDL_AUDIO_S32LE, 
  pattern SDL_AUDIO_S32BE, 
  pattern SDL_AUDIO_S32, 
  pattern SDL_AUDIO_F32LE, 
  pattern SDL_AUDIO_F32BE, 
  pattern SDL_AUDIO_F32, 

  -- Default device constants
  pattern SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK,
  pattern SDL_AUDIO_DEVICE_DEFAULT_RECORDING,
  
  -- ** Blend Mode
  BlendMode,
  pattern SDL_BLENDMODE_NONE,
  pattern SDL_BLENDMODE_BLEND,
  pattern SDL_BLENDMODE_ADD,
  pattern SDL_BLENDMODE_MOD,

  -- ** Blend Operation
  BlendOperation,
  pattern SDL_BLENDOPERATION_ADD,
  pattern SDL_BLENDOPERATION_SUBTRACT,
  pattern SDL_BLENDOPERATION_REV_SUBTRACT,
  pattern SDL_BLENDOPERATION_MINIMUM,
  pattern SDL_BLENDOPERATION_MAXIMUM,

  -- ** Blend Factor
  BlendFactor,
  pattern SDL_BLENDFACTOR_ZERO,
  pattern SDL_BLENDFACTOR_ONE,
  pattern SDL_BLENDFACTOR_SRC_COLOR,
  pattern SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR,
  pattern SDL_BLENDFACTOR_SRC_ALPHA,
  pattern SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA,
  pattern SDL_BLENDFACTOR_DST_COLOR,
  pattern SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR,
  pattern SDL_BLENDFACTOR_DST_ALPHA,
  pattern SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA,

  -- ** Endian Detetection
  pattern SDL_BYTEORDER,
  pattern SDL_LIL_ENDIAN,
  pattern SDL_BIG_ENDIAN,

  -- ** Event Action
  EventAction,
  pattern SDL_ADDEVENT,
  pattern SDL_PEEKEVENT,
  pattern SDL_GETEVENT,

  -- ** Renderer Flip Mode
  FlipMode,
  pattern SDL_FLIP_NONE,
  pattern SDL_FLIP_HORIZONTAL,
  pattern SDL_FLIP_VERTICAL,
  
  -- ** Game Controller Axis
  GamepadAxis(..),
  pattern SDL_GAMEPAD_AXIS_INVALID,
  pattern SDL_GAMEPAD_AXIS_LEFTX,
  pattern SDL_GAMEPAD_AXIS_LEFTY,
  pattern SDL_GAMEPAD_AXIS_RIGHTX,
  pattern SDL_GAMEPAD_AXIS_RIGHTY,
  pattern SDL_GAMEPAD_AXIS_LEFT_TRIGGER,
  pattern SDL_GAMEPAD_AXIS_RIGHT_TRIGGER,
  pattern SDL_GAMEPAD_AXIS_COUNT,

  -- ** Game Controller Button
  GamepadButton(..),
  pattern SDL_GAMEPAD_BUTTON_INVALID,
  pattern SDL_GAMEPAD_BUTTON_SOUTH,
  pattern SDL_GAMEPAD_BUTTON_EAST,
  pattern SDL_GAMEPAD_BUTTON_WEST,
  pattern SDL_GAMEPAD_BUTTON_NORTH,
  pattern SDL_GAMEPAD_BUTTON_BACK,
  pattern SDL_GAMEPAD_BUTTON_GUIDE,
  pattern SDL_GAMEPAD_BUTTON_START,
  pattern SDL_GAMEPAD_BUTTON_LEFT_STICK,
  pattern SDL_GAMEPAD_BUTTON_RIGHT_STICK,
  pattern SDL_GAMEPAD_BUTTON_LEFT_SHOULDER,
  pattern SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER,
  pattern SDL_GAMEPAD_BUTTON_DPAD_UP,
  pattern SDL_GAMEPAD_BUTTON_DPAD_DOWN,
  pattern SDL_GAMEPAD_BUTTON_DPAD_LEFT,
  pattern SDL_GAMEPAD_BUTTON_DPAD_RIGHT,
  pattern SDL_GAMEPAD_BUTTON_COUNT,

  -- ** Gamepad Types
  GamepadType,
  pattern SDL_GAMEPAD_TYPE_UNKNOWN,
  pattern SDL_GAMEPAD_TYPE_STANDARD,
  pattern SDL_GAMEPAD_TYPE_XBOX360,
  pattern SDL_GAMEPAD_TYPE_XBOXONE,
  pattern SDL_GAMEPAD_TYPE_PS3,
  pattern SDL_GAMEPAD_TYPE_PS4,
  pattern SDL_GAMEPAD_TYPE_PS5,
  pattern SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_PRO,
  pattern SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_LEFT,
  pattern SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_RIGHT,
  pattern SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_PAIR,
  pattern SDL_GAMEPAD_TYPE_COUNT,

  -- ** Gamepad Button Labels
  GamepadButtonLabel,
  pattern SDL_GAMEPAD_BUTTON_LABEL_UNKNOWN,
  pattern SDL_GAMEPAD_BUTTON_LABEL_A,
  pattern SDL_GAMEPAD_BUTTON_LABEL_B,
  pattern SDL_GAMEPAD_BUTTON_LABEL_X,
  pattern SDL_GAMEPAD_BUTTON_LABEL_Y,
  pattern SDL_GAMEPAD_BUTTON_LABEL_CROSS,
  pattern SDL_GAMEPAD_BUTTON_LABEL_CIRCLE,
  pattern SDL_GAMEPAD_BUTTON_LABEL_SQUARE,
  pattern SDL_GAMEPAD_BUTTON_LABEL_TRIANGLE,

  -- ** OpenGL Attribute
  GLAttr,
  pattern SDL_GL_RED_SIZE,
  pattern SDL_GL_GREEN_SIZE,
  pattern SDL_GL_BLUE_SIZE,
  pattern SDL_GL_ALPHA_SIZE,
  pattern SDL_GL_BUFFER_SIZE,
  pattern SDL_GL_DOUBLEBUFFER,
  pattern SDL_GL_DEPTH_SIZE,
  pattern SDL_GL_STENCIL_SIZE,
  pattern SDL_GL_ACCUM_RED_SIZE,
  pattern SDL_GL_ACCUM_GREEN_SIZE,
  pattern SDL_GL_ACCUM_BLUE_SIZE,
  pattern SDL_GL_ACCUM_ALPHA_SIZE,
  pattern SDL_GL_STEREO,
  pattern SDL_GL_MULTISAMPLEBUFFERS,
  pattern SDL_GL_MULTISAMPLESAMPLES,
  pattern SDL_GL_ACCELERATED_VISUAL,
  pattern SDL_GL_RETAINED_BACKING,
  pattern SDL_GL_CONTEXT_MAJOR_VERSION,
  pattern SDL_GL_CONTEXT_MINOR_VERSION,
  pattern SDL_GL_CONTEXT_FLAGS,
  pattern SDL_GL_CONTEXT_PROFILE_MASK,
  pattern SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
  pattern SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
  pattern SDL_GL_CONTEXT_RELEASE_BEHAVIOR,

  -- ** Hint Priority
  HintPriority,
  pattern SDL_HINT_DEFAULT,
  pattern SDL_HINT_NORMAL,
  pattern SDL_HINT_OVERRIDE,

  -- ** Initialization Flag
  InitFlag,
  pattern SDL_INIT_AUDIO,
  pattern SDL_INIT_VIDEO,
  pattern SDL_INIT_JOYSTICK,
  pattern SDL_INIT_HAPTIC,
  pattern SDL_INIT_GAMEPAD,
  pattern SDL_INIT_EVENTS,

    -- ** Keycode
  Keycode,
  pattern SDLK_UNKNOWN,
  pattern SDLK_RETURN,
  pattern SDLK_ESCAPE,
  pattern SDLK_BACKSPACE,
  pattern SDLK_TAB,
  pattern SDLK_SPACE,
  pattern SDLK_EXCLAIM,
  pattern SDLK_DBLAPOSTROPHE,
  pattern SDLK_HASH,
  pattern SDLK_PERCENT,
  pattern SDLK_DOLLAR,
  pattern SDLK_AMPERSAND,
  pattern SDLK_APOSTROPHE,
  pattern SDLK_LEFTPAREN,
  pattern SDLK_RIGHTPAREN,
  pattern SDLK_ASTERISK,
  pattern SDLK_PLUS,
  pattern SDLK_COMMA,
  pattern SDLK_MINUS,
  pattern SDLK_PERIOD,
  pattern SDLK_SLASH,
  pattern SDLK_0,
  pattern SDLK_1,
  pattern SDLK_2,
  pattern SDLK_3,
  pattern SDLK_4,
  pattern SDLK_5,
  pattern SDLK_6,
  pattern SDLK_7,
  pattern SDLK_8,
  pattern SDLK_9,
  pattern SDLK_COLON,
  pattern SDLK_SEMICOLON,
  pattern SDLK_LESS,
  pattern SDLK_EQUALS,
  pattern SDLK_GREATER,
  pattern SDLK_QUESTION,
  pattern SDLK_AT,
  pattern SDLK_LEFTBRACKET,
  pattern SDLK_BACKSLASH,
  pattern SDLK_RIGHTBRACKET,
  pattern SDLK_CARET,
  pattern SDLK_UNDERSCORE,
  pattern SDLK_GRAVE,
  pattern SDLK_A,
  pattern SDLK_B,
  pattern SDLK_C,
  pattern SDLK_D,
  pattern SDLK_E,
  pattern SDLK_F,
  pattern SDLK_G,
  pattern SDLK_H,
  pattern SDLK_I,
  pattern SDLK_J,
  pattern SDLK_K,
  pattern SDLK_L,
  pattern SDLK_M,
  pattern SDLK_N,
  pattern SDLK_O,
  pattern SDLK_P,
  pattern SDLK_Q,
  pattern SDLK_R,
  pattern SDLK_S,
  pattern SDLK_T,
  pattern SDLK_U,
  pattern SDLK_V,
  pattern SDLK_W,
  pattern SDLK_X,
  pattern SDLK_Y,
  pattern SDLK_Z,
  pattern SDLK_CAPSLOCK,
  pattern SDLK_F1,
  pattern SDLK_F2,
  pattern SDLK_F3,
  pattern SDLK_F4,
  pattern SDLK_F5,
  pattern SDLK_F6,
  pattern SDLK_F7,
  pattern SDLK_F8,
  pattern SDLK_F9,
  pattern SDLK_F10,
  pattern SDLK_F11,
  pattern SDLK_F12,
  pattern SDLK_PRINTSCREEN,
  pattern SDLK_SCROLLLOCK,
  pattern SDLK_PAUSE,
  pattern SDLK_INSERT,
  pattern SDLK_HOME,
  pattern SDLK_PAGEUP,
  pattern SDLK_DELETE,
  pattern SDLK_END,
  pattern SDLK_PAGEDOWN,
  pattern SDLK_RIGHT,
  pattern SDLK_LEFT,
  pattern SDLK_DOWN,
  pattern SDLK_UP,
  pattern SDLK_NUMLOCKCLEAR,
  pattern SDLK_KP_DIVIDE,
  pattern SDLK_KP_MULTIPLY,
  pattern SDLK_KP_MINUS,
  pattern SDLK_KP_PLUS,
  pattern SDLK_KP_ENTER,
  pattern SDLK_KP_1,
  pattern SDLK_KP_2,
  pattern SDLK_KP_3,
  pattern SDLK_KP_4,
  pattern SDLK_KP_5,
  pattern SDLK_KP_6,
  pattern SDLK_KP_7,
  pattern SDLK_KP_8,
  pattern SDLK_KP_9,
  pattern SDLK_KP_0,
  pattern SDLK_KP_PERIOD,
  pattern SDLK_APPLICATION,
  pattern SDLK_POWER,
  pattern SDLK_KP_EQUALS,
  pattern SDLK_F13,
  pattern SDLK_F14,
  pattern SDLK_F15,
  pattern SDLK_F16,
  pattern SDLK_F17,
  pattern SDLK_F18,
  pattern SDLK_F19,
  pattern SDLK_F20,
  pattern SDLK_F21,
  pattern SDLK_F22,
  pattern SDLK_F23,
  pattern SDLK_F24,
  pattern SDLK_EXECUTE,
  pattern SDLK_HELP,
  pattern SDLK_MENU,
  pattern SDLK_SELECT,
  pattern SDLK_STOP,
  pattern SDLK_AGAIN,
  pattern SDLK_UNDO,
  pattern SDLK_CUT,
  pattern SDLK_COPY,
  pattern SDLK_PASTE,
  pattern SDLK_FIND,
  pattern SDLK_MUTE,
  pattern SDLK_VOLUMEUP,
  pattern SDLK_VOLUMEDOWN,
  pattern SDLK_KP_COMMA,
  pattern SDLK_KP_EQUALSAS400,
  pattern SDLK_ALTERASE,
  pattern SDLK_SYSREQ,
  pattern SDLK_CANCEL,
  pattern SDLK_CLEAR,
  pattern SDLK_PRIOR,
  pattern SDLK_RETURN2,
  pattern SDLK_SEPARATOR,
  pattern SDLK_OUT,
  pattern SDLK_OPER,
  pattern SDLK_CLEARAGAIN,
  pattern SDLK_CRSEL,
  pattern SDLK_EXSEL,
  pattern SDLK_KP_00,
  pattern SDLK_KP_000,
  pattern SDLK_THOUSANDSSEPARATOR,
  pattern SDLK_DECIMALSEPARATOR,
  pattern SDLK_CURRENCYUNIT,
  pattern SDLK_CURRENCYSUBUNIT,
  pattern SDLK_KP_LEFTPAREN,
  pattern SDLK_KP_RIGHTPAREN,
  pattern SDLK_KP_LEFTBRACE,
  pattern SDLK_KP_RIGHTBRACE,
  pattern SDLK_KP_TAB,
  pattern SDLK_KP_BACKSPACE,
  pattern SDLK_KP_A,
  pattern SDLK_KP_B,
  pattern SDLK_KP_C,
  pattern SDLK_KP_D,
  pattern SDLK_KP_E,
  pattern SDLK_KP_F,
  pattern SDLK_KP_XOR,
  pattern SDLK_KP_POWER,
  pattern SDLK_KP_PERCENT,
  pattern SDLK_KP_LESS,
  pattern SDLK_KP_GREATER,
  pattern SDLK_KP_AMPERSAND,
  pattern SDLK_KP_DBLAMPERSAND,
  pattern SDLK_KP_VERTICALBAR,
  pattern SDLK_KP_DBLVERTICALBAR,
  pattern SDLK_KP_COLON,
  pattern SDLK_KP_HASH,
  pattern SDLK_KP_SPACE,
  pattern SDLK_KP_AT,
  pattern SDLK_KP_EXCLAM,
  pattern SDLK_KP_MEMSTORE,
  pattern SDLK_KP_MEMRECALL,
  pattern SDLK_KP_MEMCLEAR,
  pattern SDLK_KP_MEMADD,
  pattern SDLK_KP_MEMSUBTRACT,
  pattern SDLK_KP_MEMMULTIPLY,
  pattern SDLK_KP_MEMDIVIDE,
  pattern SDLK_KP_PLUSMINUS,
  pattern SDLK_KP_CLEAR,
  pattern SDLK_KP_CLEARENTRY,
  pattern SDLK_KP_BINARY,
  pattern SDLK_KP_OCTAL,
  pattern SDLK_KP_DECIMAL,
  pattern SDLK_KP_HEXADECIMAL,
  pattern SDLK_LCTRL,
  pattern SDLK_LSHIFT,
  pattern SDLK_LALT,
  pattern SDLK_LGUI,
  pattern SDLK_RCTRL,
  pattern SDLK_RSHIFT,
  pattern SDLK_RALT,
  pattern SDLK_RGUI,
  pattern SDLK_MODE,
  pattern SDLK_MEDIA_NEXT_TRACK,
  pattern SDLK_MEDIA_PREVIOUS_TRACK,
  pattern SDLK_MEDIA_STOP,
  pattern SDLK_MEDIA_PLAY,
  pattern SDLK_MEDIA_SELECT,
  pattern SDLK_AC_SEARCH,
  pattern SDLK_AC_HOME,
  pattern SDLK_AC_BACK,
  pattern SDLK_AC_FORWARD,
  pattern SDLK_AC_STOP,
  pattern SDLK_AC_REFRESH,
  pattern SDLK_AC_BOOKMARKS,
  pattern SDLK_MEDIA_EJECT,
  pattern SDLK_SLEEP,

  -- ** Key Modifier
  Keymod,
  pattern SDL_KMOD_NONE,
  pattern SDL_KMOD_LSHIFT,
  pattern SDL_KMOD_RSHIFT,
  pattern SDL_KMOD_SHIFT,
  pattern SDL_KMOD_LCTRL,
  pattern SDL_KMOD_RCTRL,
  pattern SDL_KMOD_CTRL,
  pattern SDL_KMOD_LALT,
  pattern SDL_KMOD_RALT,
  pattern SDL_KMOD_ALT,
  pattern SDL_KMOD_LGUI,
  pattern SDL_KMOD_RGUI,
  pattern SDL_KMOD_GUI,
  pattern SDL_KMOD_NUM,
  pattern SDL_KMOD_CAPS,
  pattern SDL_KMOD_MODE,

  -- ** Log Priority
  LogPriority,
  pattern SDL_LOG_PRIORITY_VERBOSE,
  pattern SDL_LOG_PRIORITY_DEBUG,
  pattern SDL_LOG_PRIORITY_INFO,
  pattern SDL_LOG_PRIORITY_WARN,
  pattern SDL_LOG_PRIORITY_ERROR,
  pattern SDL_LOG_PRIORITY_CRITICAL,
  pattern SDL_LOG_PRIORITY_COUNT,

  -- ** Power State
  PowerState,
  pattern SDL_POWERSTATE_ERROR,
  pattern SDL_POWERSTATE_UNKNOWN,
  pattern SDL_POWERSTATE_ON_BATTERY,
  pattern SDL_POWERSTATE_NO_BATTERY,
  pattern SDL_POWERSTATE_CHARGING,
  pattern SDL_POWERSTATE_CHARGED,  

  -- ** Renderer Logical Presentation
  RendererLogicalPresentation,
  pattern SDL_LOGICAL_PRESENTATION_DISABLED,
  pattern SDL_LOGICAL_PRESENTATION_STRETCH,
  pattern SDL_LOGICAL_PRESENTATION_LETTERBOX,
  pattern SDL_LOGICAL_PRESENTATION_OVERSCAN,   
  pattern SDL_LOGICAL_PRESENTATION_INTEGER_SCALE, 

  -- ** Renderer Scale Mode
  ScaleMode,
  pattern SDL_SCALEMODE_NEAREST,
  pattern SDL_SCALEMODE_LINEAR,

  -- ** Scancode
  Scancode,
  pattern SDL_SCANCODE_UNKNOWN,
  pattern SDL_SCANCODE_A,
  pattern SDL_SCANCODE_B,
  pattern SDL_SCANCODE_C,
  pattern SDL_SCANCODE_D,
  pattern SDL_SCANCODE_E,
  pattern SDL_SCANCODE_F,
  pattern SDL_SCANCODE_G,
  pattern SDL_SCANCODE_H,
  pattern SDL_SCANCODE_I,
  pattern SDL_SCANCODE_J,
  pattern SDL_SCANCODE_K,
  pattern SDL_SCANCODE_L,
  pattern SDL_SCANCODE_M,
  pattern SDL_SCANCODE_N,
  pattern SDL_SCANCODE_O,
  pattern SDL_SCANCODE_P,
  pattern SDL_SCANCODE_Q,
  pattern SDL_SCANCODE_R,
  pattern SDL_SCANCODE_S,
  pattern SDL_SCANCODE_T,
  pattern SDL_SCANCODE_U,
  pattern SDL_SCANCODE_V,
  pattern SDL_SCANCODE_W,
  pattern SDL_SCANCODE_X,
  pattern SDL_SCANCODE_Y,
  pattern SDL_SCANCODE_Z,
  pattern SDL_SCANCODE_1,
  pattern SDL_SCANCODE_2,
  pattern SDL_SCANCODE_3,
  pattern SDL_SCANCODE_4,
  pattern SDL_SCANCODE_5,
  pattern SDL_SCANCODE_6,
  pattern SDL_SCANCODE_7,
  pattern SDL_SCANCODE_8,
  pattern SDL_SCANCODE_9,
  pattern SDL_SCANCODE_0,
  pattern SDL_SCANCODE_RETURN,
  pattern SDL_SCANCODE_ESCAPE,
  pattern SDL_SCANCODE_BACKSPACE,
  pattern SDL_SCANCODE_TAB,
  pattern SDL_SCANCODE_SPACE,
  pattern SDL_SCANCODE_MINUS,
  pattern SDL_SCANCODE_EQUALS,
  pattern SDL_SCANCODE_LEFTBRACKET,
  pattern SDL_SCANCODE_RIGHTBRACKET,
  pattern SDL_SCANCODE_BACKSLASH,
  pattern SDL_SCANCODE_NONUSHASH,
  pattern SDL_SCANCODE_SEMICOLON,
  pattern SDL_SCANCODE_APOSTROPHE,
  pattern SDL_SCANCODE_GRAVE,
  pattern SDL_SCANCODE_COMMA,
  pattern SDL_SCANCODE_PERIOD,
  pattern SDL_SCANCODE_SLASH,
  pattern SDL_SCANCODE_CAPSLOCK,
  pattern SDL_SCANCODE_F1,
  pattern SDL_SCANCODE_F2,
  pattern SDL_SCANCODE_F3,
  pattern SDL_SCANCODE_F4,
  pattern SDL_SCANCODE_F5,
  pattern SDL_SCANCODE_F6,
  pattern SDL_SCANCODE_F7,
  pattern SDL_SCANCODE_F8,
  pattern SDL_SCANCODE_F9,
  pattern SDL_SCANCODE_F10,
  pattern SDL_SCANCODE_F11,
  pattern SDL_SCANCODE_F12,
  pattern SDL_SCANCODE_PRINTSCREEN,
  pattern SDL_SCANCODE_SCROLLLOCK,
  pattern SDL_SCANCODE_PAUSE,
  pattern SDL_SCANCODE_INSERT,
  pattern SDL_SCANCODE_HOME,
  pattern SDL_SCANCODE_PAGEUP,
  pattern SDL_SCANCODE_DELETE,
  pattern SDL_SCANCODE_END,
  pattern SDL_SCANCODE_PAGEDOWN,
  pattern SDL_SCANCODE_RIGHT,
  pattern SDL_SCANCODE_LEFT,
  pattern SDL_SCANCODE_DOWN,
  pattern SDL_SCANCODE_UP,
  pattern SDL_SCANCODE_NUMLOCKCLEAR,
  pattern SDL_SCANCODE_KP_DIVIDE,
  pattern SDL_SCANCODE_KP_MULTIPLY,
  pattern SDL_SCANCODE_KP_MINUS,
  pattern SDL_SCANCODE_KP_PLUS,
  pattern SDL_SCANCODE_KP_ENTER,
  pattern SDL_SCANCODE_KP_1,
  pattern SDL_SCANCODE_KP_2,
  pattern SDL_SCANCODE_KP_3,
  pattern SDL_SCANCODE_KP_4,
  pattern SDL_SCANCODE_KP_5,
  pattern SDL_SCANCODE_KP_6,
  pattern SDL_SCANCODE_KP_7,
  pattern SDL_SCANCODE_KP_8,
  pattern SDL_SCANCODE_KP_9,
  pattern SDL_SCANCODE_KP_0,
  pattern SDL_SCANCODE_KP_PERIOD,
  pattern SDL_SCANCODE_NONUSBACKSLASH,
  pattern SDL_SCANCODE_APPLICATION,
  pattern SDL_SCANCODE_POWER,
  pattern SDL_SCANCODE_KP_EQUALS,
  pattern SDL_SCANCODE_F13,
  pattern SDL_SCANCODE_F14,
  pattern SDL_SCANCODE_F15,
  pattern SDL_SCANCODE_F16,
  pattern SDL_SCANCODE_F17,
  pattern SDL_SCANCODE_F18,
  pattern SDL_SCANCODE_F19,
  pattern SDL_SCANCODE_F20,
  pattern SDL_SCANCODE_F21,
  pattern SDL_SCANCODE_F22,
  pattern SDL_SCANCODE_F23,
  pattern SDL_SCANCODE_F24,
  pattern SDL_SCANCODE_EXECUTE,
  pattern SDL_SCANCODE_HELP,
  pattern SDL_SCANCODE_MENU,
  pattern SDL_SCANCODE_SELECT,
  pattern SDL_SCANCODE_STOP,
  pattern SDL_SCANCODE_AGAIN,
  pattern SDL_SCANCODE_UNDO,
  pattern SDL_SCANCODE_CUT,
  pattern SDL_SCANCODE_COPY,
  pattern SDL_SCANCODE_PASTE,
  pattern SDL_SCANCODE_FIND,
  pattern SDL_SCANCODE_MUTE,
  pattern SDL_SCANCODE_VOLUMEUP,
  pattern SDL_SCANCODE_VOLUMEDOWN,
  pattern SDL_SCANCODE_KP_COMMA,
  pattern SDL_SCANCODE_KP_EQUALSAS400,
  pattern SDL_SCANCODE_INTERNATIONAL1,
  pattern SDL_SCANCODE_INTERNATIONAL2,
  pattern SDL_SCANCODE_INTERNATIONAL3,
  pattern SDL_SCANCODE_INTERNATIONAL4,
  pattern SDL_SCANCODE_INTERNATIONAL5,
  pattern SDL_SCANCODE_INTERNATIONAL6,
  pattern SDL_SCANCODE_INTERNATIONAL7,
  pattern SDL_SCANCODE_INTERNATIONAL8,
  pattern SDL_SCANCODE_INTERNATIONAL9,
  pattern SDL_SCANCODE_LANG1,
  pattern SDL_SCANCODE_LANG2,
  pattern SDL_SCANCODE_LANG3,
  pattern SDL_SCANCODE_LANG4,
  pattern SDL_SCANCODE_LANG5,
  pattern SDL_SCANCODE_LANG6,
  pattern SDL_SCANCODE_LANG7,
  pattern SDL_SCANCODE_LANG8,
  pattern SDL_SCANCODE_LANG9,
  pattern SDL_SCANCODE_ALTERASE,
  pattern SDL_SCANCODE_SYSREQ,
  pattern SDL_SCANCODE_CANCEL,
  pattern SDL_SCANCODE_CLEAR,
  pattern SDL_SCANCODE_PRIOR,
  pattern SDL_SCANCODE_RETURN2,
  pattern SDL_SCANCODE_SEPARATOR,
  pattern SDL_SCANCODE_OUT,
  pattern SDL_SCANCODE_OPER,
  pattern SDL_SCANCODE_CLEARAGAIN,
  pattern SDL_SCANCODE_CRSEL,
  pattern SDL_SCANCODE_EXSEL,
  pattern SDL_SCANCODE_KP_00,
  pattern SDL_SCANCODE_KP_000,
  pattern SDL_SCANCODE_THOUSANDSSEPARATOR,
  pattern SDL_SCANCODE_DECIMALSEPARATOR,
  pattern SDL_SCANCODE_CURRENCYUNIT,
  pattern SDL_SCANCODE_CURRENCYSUBUNIT,
  pattern SDL_SCANCODE_KP_LEFTPAREN,
  pattern SDL_SCANCODE_KP_RIGHTPAREN,
  pattern SDL_SCANCODE_KP_LEFTBRACE,
  pattern SDL_SCANCODE_KP_RIGHTBRACE,
  pattern SDL_SCANCODE_KP_TAB,
  pattern SDL_SCANCODE_KP_BACKSPACE,
  pattern SDL_SCANCODE_KP_A,
  pattern SDL_SCANCODE_KP_B,
  pattern SDL_SCANCODE_KP_C,
  pattern SDL_SCANCODE_KP_D,
  pattern SDL_SCANCODE_KP_E,
  pattern SDL_SCANCODE_KP_F,
  pattern SDL_SCANCODE_KP_XOR,
  pattern SDL_SCANCODE_KP_POWER,
  pattern SDL_SCANCODE_KP_PERCENT,
  pattern SDL_SCANCODE_KP_LESS,
  pattern SDL_SCANCODE_KP_GREATER,
  pattern SDL_SCANCODE_KP_AMPERSAND,
  pattern SDL_SCANCODE_KP_DBLAMPERSAND,
  pattern SDL_SCANCODE_KP_VERTICALBAR,
  pattern SDL_SCANCODE_KP_DBLVERTICALBAR,
  pattern SDL_SCANCODE_KP_COLON,
  pattern SDL_SCANCODE_KP_HASH,
  pattern SDL_SCANCODE_KP_SPACE,
  pattern SDL_SCANCODE_KP_AT,
  pattern SDL_SCANCODE_KP_EXCLAM,
  pattern SDL_SCANCODE_KP_MEMSTORE,
  pattern SDL_SCANCODE_KP_MEMRECALL,
  pattern SDL_SCANCODE_KP_MEMCLEAR,
  pattern SDL_SCANCODE_KP_MEMADD,
  pattern SDL_SCANCODE_KP_MEMSUBTRACT,
  pattern SDL_SCANCODE_KP_MEMMULTIPLY,
  pattern SDL_SCANCODE_KP_MEMDIVIDE,
  pattern SDL_SCANCODE_KP_PLUSMINUS,
  pattern SDL_SCANCODE_KP_CLEAR,
  pattern SDL_SCANCODE_KP_CLEARENTRY,
  pattern SDL_SCANCODE_KP_BINARY,
  pattern SDL_SCANCODE_KP_OCTAL,
  pattern SDL_SCANCODE_KP_DECIMAL,
  pattern SDL_SCANCODE_KP_HEXADECIMAL,
  pattern SDL_SCANCODE_LCTRL,
  pattern SDL_SCANCODE_LSHIFT,
  pattern SDL_SCANCODE_LALT,
  pattern SDL_SCANCODE_LGUI,
  pattern SDL_SCANCODE_RCTRL,
  pattern SDL_SCANCODE_RSHIFT,
  pattern SDL_SCANCODE_RALT,
  pattern SDL_SCANCODE_RGUI,
  pattern SDL_SCANCODE_MODE,
  pattern SDL_SCANCODE_MEDIA_NEXT_TRACK,
  pattern SDL_SCANCODE_MEDIA_PREVIOUS_TRACK,
  pattern SDL_SCANCODE_MEDIA_STOP,
  pattern SDL_SCANCODE_MEDIA_PLAY,
  pattern SDL_SCANCODE_AC_SEARCH,
  pattern SDL_SCANCODE_AC_HOME,
  pattern SDL_SCANCODE_AC_BACK,
  pattern SDL_SCANCODE_AC_FORWARD,
  pattern SDL_SCANCODE_AC_STOP,
  pattern SDL_SCANCODE_AC_REFRESH,
  pattern SDL_SCANCODE_AC_BOOKMARKS,
  pattern SDL_SCANCODE_MEDIA_EJECT,
  pattern SDL_SCANCODE_SLEEP,
  pattern SDL_SCANCODE_COUNT,

  -- ** Sensor Types
  SensorType,
  pattern SDL_SENSOR_INVALID,
  pattern SDL_SENSOR_UNKNOWN,
  pattern SDL_SENSOR_ACCEL,
  pattern SDL_SENSOR_GYRO,
  pattern SDL_SENSOR_ACCEL_L,
  pattern SDL_SENSOR_GYRO_L,
  pattern SDL_SENSOR_ACCEL_R,
  pattern SDL_SENSOR_GYRO_R,

  -- ** System Cursor
  SystemCursor,
  pattern SDL_SYSTEM_CURSOR_DEFAULT,
  pattern SDL_SYSTEM_CURSOR_TEXT,
  pattern SDL_SYSTEM_CURSOR_WAIT,
  pattern SDL_SYSTEM_CURSOR_CROSSHAIR,
  pattern SDL_SYSTEM_CURSOR_PROGRESS,
  pattern SDL_SYSTEM_CURSOR_NWSE_RESIZE,
  pattern SDL_SYSTEM_CURSOR_NESW_RESIZE,
  pattern SDL_SYSTEM_CURSOR_EW_RESIZE,
  pattern SDL_SYSTEM_CURSOR_NS_RESIZE,
  pattern SDL_SYSTEM_CURSOR_MOVE,
  pattern SDL_SYSTEM_CURSOR_NOT_ALLOWED,
  pattern SDL_SYSTEM_CURSOR_POINTER,
  pattern SDL_SYSTEM_CURSOR_COUNT,

  -- ** Thread Priority
  ThreadPriority,
  pattern SDL_THREAD_PRIORITY_LOW,
  pattern SDL_THREAD_PRIORITY_NORMAL,
  pattern SDL_THREAD_PRIORITY_HIGH,

  -- * Miscellaneous Enumerations
  -- | These enumerations are not used directly by any SDL function, thus they have a polymorphic type.

  -- ** Mouse Buttons
  pattern SDL_BUTTON_LEFT,
  pattern SDL_BUTTON_MIDDLE,
  pattern SDL_BUTTON_RIGHT,
  pattern SDL_BUTTON_X1,
  pattern SDL_BUTTON_X2,

  -- ** Mouse Button Masks
  pattern SDL_BUTTON_LMASK,
  pattern SDL_BUTTON_MMASK,
  pattern SDL_BUTTON_RMASK,
  pattern SDL_BUTTON_X1MASK,
  pattern SDL_BUTTON_X2MASK,

  -- ** Mouse Wheel Direction
  pattern SDL_MOUSEWHEEL_NORMAL,
  pattern SDL_MOUSEWHEEL_FLIPPED,

  -- ** Event Type
  pattern SDL_EVENT_FIRST,
  pattern SDL_EVENT_QUIT,
  pattern SDL_EVENT_TERMINATING,
  pattern SDL_EVENT_LOW_MEMORY,
  pattern SDL_EVENT_WILL_ENTER_BACKGROUND,
  pattern SDL_EVENT_DID_ENTER_BACKGROUND,
  pattern SDL_EVENT_WILL_ENTER_FOREGROUND,
  pattern SDL_EVENT_DID_ENTER_FOREGROUND,
  pattern SDL_EVENT_KEY_DOWN,
  pattern SDL_EVENT_KEY_UP,
  pattern SDL_EVENT_TEXT_EDITING,
  pattern SDL_EVENT_TEXT_INPUT,
  pattern SDL_EVENT_KEYMAP_CHANGED,
  pattern SDL_EVENT_MOUSE_MOTION,
  pattern SDL_EVENT_MOUSE_BUTTON_DOWN,
  pattern SDL_EVENT_MOUSE_BUTTON_UP,
  pattern SDL_EVENT_MOUSE_WHEEL,
  pattern SDL_EVENT_JOYSTICK_AXIS_MOTION,
  pattern SDL_EVENT_JOYSTICK_BALL_MOTION,
  pattern SDL_EVENT_JOYSTICK_HAT_MOTION,
  pattern SDL_EVENT_JOYSTICK_BUTTON_DOWN,
  pattern SDL_EVENT_JOYSTICK_BUTTON_UP,
  pattern SDL_EVENT_JOYSTICK_ADDED,
  pattern SDL_EVENT_JOYSTICK_REMOVED,
  pattern SDL_EVENT_GAMEPAD_AXIS_MOTION,
  pattern SDL_EVENT_GAMEPAD_BUTTON_DOWN,
  pattern SDL_EVENT_GAMEPAD_BUTTON_UP,
  pattern SDL_EVENT_GAMEPAD_ADDED,
  pattern SDL_EVENT_GAMEPAD_REMOVED,
  pattern SDL_EVENT_GAMEPAD_REMAPPED,
  pattern SDL_EVENT_FINGER_DOWN,
  pattern SDL_EVENT_FINGER_UP,
  pattern SDL_EVENT_FINGER_MOTION,
  pattern SDL_EVENT_CLIPBOARD_UPDATE,
  pattern SDL_EVENT_DROP_FILE,
  pattern SDL_EVENT_AUDIO_DEVICE_ADDED,
  pattern SDL_EVENT_AUDIO_DEVICE_REMOVED,
  pattern SDL_EVENT_RENDER_TARGETS_RESET,
  pattern SDL_EVENT_RENDER_DEVICE_RESET,
  pattern SDL_EVENT_USER,
  pattern SDL_EVENT_LAST,

  -- ** Joystick Types
  JoystickType,
  pattern SDL_JOYSTICK_TYPE_UNKNOWN,
  pattern SDL_JOYSTICK_TYPE_GAMEPAD,
  pattern SDL_JOYSTICK_TYPE_WHEEL,
  pattern SDL_JOYSTICK_TYPE_ARCADE_STICK,
  pattern SDL_JOYSTICK_TYPE_FLIGHT_STICK,
  pattern SDL_JOYSTICK_TYPE_DANCE_PAD,
  pattern SDL_JOYSTICK_TYPE_GUITAR,
  pattern SDL_JOYSTICK_TYPE_DRUM_KIT,
  pattern SDL_JOYSTICK_TYPE_ARCADE_PAD,
  pattern SDL_JOYSTICK_TYPE_THROTTLE,
  pattern SDL_JOYSTICK_TYPE_COUNT,

  -- ** Joystick Connection States
  JoystickConnectionState,
  pattern SDL_JOYSTICK_CONNECTION_INVALID,
  pattern SDL_JOYSTICK_CONNECTION_UNKNOWN, 
  pattern SDL_JOYSTICK_CONNECTION_WIRED, 
  pattern SDL_JOYSTICK_CONNECTION_WIRELESS, 

  -- ** Joystick Hat Position
  pattern SDL_HAT_CENTERED,
  pattern SDL_HAT_UP,
  pattern SDL_HAT_RIGHT,
  pattern SDL_HAT_DOWN,
  pattern SDL_HAT_LEFT,
  pattern SDL_HAT_RIGHTUP,
  pattern SDL_HAT_RIGHTDOWN,
  pattern SDL_HAT_LEFTUP,
  pattern SDL_HAT_LEFTDOWN,

  -- ** Log Category
  pattern SDL_LOG_CATEGORY_APPLICATION,
  pattern SDL_LOG_CATEGORY_ERROR,
  pattern SDL_LOG_CATEGORY_ASSERT,
  pattern SDL_LOG_CATEGORY_SYSTEM,
  pattern SDL_LOG_CATEGORY_AUDIO,
  pattern SDL_LOG_CATEGORY_VIDEO,
  pattern SDL_LOG_CATEGORY_RENDER,
  pattern SDL_LOG_CATEGORY_INPUT,
  pattern SDL_LOG_CATEGORY_TEST,
  pattern SDL_LOG_CATEGORY_CUSTOM,

  -- ** Message Box Flags
  pattern SDL_MESSAGEBOX_ERROR,
  pattern SDL_MESSAGEBOX_WARNING,
  pattern SDL_MESSAGEBOX_INFORMATION,

  -- ** Message Box Button Flags
  pattern SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT,
  pattern SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT,

  -- ** OpenGL Profile
  pattern SDL_GL_CONTEXT_PROFILE_CORE,
  pattern SDL_GL_CONTEXT_PROFILE_COMPATIBILITY,
  pattern SDL_GL_CONTEXT_PROFILE_ES,

  -- ** OpenGL Context Flag
  pattern SDL_GL_CONTEXT_DEBUG_FLAG,
  pattern SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG,
  pattern SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG,
  pattern SDL_GL_CONTEXT_RESET_ISOLATION_FLAG,

  -- ** OpenGL Context Release Behavior Flag
  pattern SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE,
  pattern SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH,

  -- ** Pixel Formats
  pattern SDL_PIXELFORMAT_UNKNOWN,
  pattern SDL_PIXELFORMAT_INDEX1LSB,
  pattern SDL_PIXELFORMAT_INDEX1MSB,
  pattern SDL_PIXELFORMAT_INDEX4LSB,
  pattern SDL_PIXELFORMAT_INDEX4MSB,
  pattern SDL_PIXELFORMAT_INDEX8,
  pattern SDL_PIXELFORMAT_RGB332,
  pattern SDL_PIXELFORMAT_XRGB4444,
  pattern SDL_PIXELFORMAT_XRGB1555,
  pattern SDL_PIXELFORMAT_XBGR1555,
  pattern SDL_PIXELFORMAT_ARGB4444,
  pattern SDL_PIXELFORMAT_RGBA4444,
  pattern SDL_PIXELFORMAT_ABGR4444,
  pattern SDL_PIXELFORMAT_BGRA4444,
  pattern SDL_PIXELFORMAT_ARGB1555,
  pattern SDL_PIXELFORMAT_RGBA5551,
  pattern SDL_PIXELFORMAT_ABGR1555,
  pattern SDL_PIXELFORMAT_BGRA5551,
  pattern SDL_PIXELFORMAT_RGB565,
  pattern SDL_PIXELFORMAT_BGR565,
  pattern SDL_PIXELFORMAT_RGB24,
  pattern SDL_PIXELFORMAT_BGR24,
  pattern SDL_PIXELFORMAT_XRGB8888,
  pattern SDL_PIXELFORMAT_RGBX8888,
  pattern SDL_PIXELFORMAT_XBGR8888,
  pattern SDL_PIXELFORMAT_BGRX8888,
  pattern SDL_PIXELFORMAT_ARGB8888,
  pattern SDL_PIXELFORMAT_RGBA8888,
  pattern SDL_PIXELFORMAT_ABGR8888,
  pattern SDL_PIXELFORMAT_BGRA8888,
  pattern SDL_PIXELFORMAT_ARGB2101010,
  pattern SDL_PIXELFORMAT_YV12,
  pattern SDL_PIXELFORMAT_IYUV,
  pattern SDL_PIXELFORMAT_YUY2,
  pattern SDL_PIXELFORMAT_UYVY,
  pattern SDL_PIXELFORMAT_YVYU,
  
  -- ** Texture Access
  TextureAccess,
  pattern SDL_TEXTUREACCESS_STATIC,
  pattern SDL_TEXTUREACCESS_STREAMING,
  pattern SDL_TEXTUREACCESS_TARGET,

    -- ** Touch
  pattern SDL_TOUCH_MOUSEID,

  -- ** Window Event
  pattern SDL_EVENT_WINDOW_HIDDEN,
  pattern SDL_EVENT_WINDOW_EXPOSED,
  pattern SDL_EVENT_WINDOW_MOVED,
  pattern SDL_EVENT_WINDOW_RESIZED,
  pattern SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED,
  pattern SDL_EVENT_WINDOW_MINIMIZED,
  pattern SDL_EVENT_WINDOW_MAXIMIZED,
  pattern SDL_EVENT_WINDOW_RESTORED,
  pattern SDL_EVENT_WINDOW_MOUSE_ENTER,
  pattern SDL_EVENT_WINDOW_MOUSE_LEAVE,
  pattern SDL_EVENT_WINDOW_FOCUS_GAINED,
  pattern SDL_EVENT_WINDOW_FOCUS_LOST,
  pattern SDL_EVENT_WINDOW_CLOSE_REQUESTED,

  -- ** Window Flags
  pattern SDL_WINDOW_FULLSCREEN,
  pattern SDL_WINDOW_OPENGL,
  pattern SDL_WINDOW_BORDERLESS,
  pattern SDL_WINDOW_RESIZABLE,
  pattern SDL_WINDOW_MINIMIZED,
  pattern SDL_WINDOW_MAXIMIZED,
  pattern SDL_WINDOW_MOUSE_GRABBED,
  pattern SDL_WINDOW_INPUT_FOCUS,
  pattern SDL_WINDOW_MOUSE_FOCUS,
  pattern SDL_WINDOW_HIGH_PIXEL_DENSITY,
  pattern SDL_WINDOW_MOUSE_CAPTURE,
  pattern SDL_WINDOW_VULKAN,

  -- ** Window Positioning
  pattern SDL_WINDOWPOS_UNDEFINED,
  pattern SDL_WINDOWPOS_CENTERED,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_0,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_1,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_2,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_3,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_4,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_5,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_6,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_7,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_8,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_9,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_10,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_11,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_12,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_13,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_14,
  pattern SDL_WINDOWPOS_CENTERED_DISPLAY_15,

  -- ** Haptic Event Types
  pattern SDL_HAPTIC_CONSTANT
) where

#include "SDL3/SDL.h"

import Data.Int
import Data.Word

import Foreign.C.Types
import Foreign.Storable (Storable(..))
import Foreign.Ptr (Ptr, plusPtr, castPtr)

type AudioFormat = (#type SDL_AudioFormat)
type AudioDeviceID = (#type SDL_AudioDeviceID)
type BlendMode = (#type SDL_BlendMode)
type BlendOperation = (#type SDL_BlendOperation)
type BlendFactor = (#type SDL_BlendFactor)
type Endian = CInt
type EventAction = (#type SDL_EventAction)
type FlipMode = (#type SDL_FlipMode)

newtype GamepadAxis = GamepadAxis (#type SDL_GamepadAxis)
  deriving (Eq, Show)


newtype GamepadButton = GamepadButton (#type SDL_GamepadButton)
  deriving (Eq, Show)

 
type GamepadType = (#type SDL_GamepadType)
type GamepadButtonLabel = (#type SDL_GamepadButtonLabel)
type SensorType = (#type SDL_SensorType)
type GLAttr = (#type SDL_GLAttr)
type HintPriority = (#type SDL_HintPriority)
type InitFlag = Word32
type JoystickType = (#type SDL_JoystickType)
type JoystickConnectionState = (#type SDL_JoystickConnectionState)
type Keycode = (#type SDL_Keycode)
type Keymod = (#type SDL_Keymod)
type LogPriority = (#type SDL_LogPriority)
type PowerState = (#type SDL_PowerState)
type RendererLogicalPresentation = (#type SDL_RendererLogicalPresentation)
type ScaleMode = (#type SDL_ScaleMode)
type Scancode = (#type SDL_Scancode)
type SystemCursor = (#type SDL_SystemCursor)
type TextureAccess = (#type SDL_TextureAccess)
type ThreadPriority = (#type SDL_ThreadPriority)

pattern SDL_AUDIO_U8 = (#const SDL_AUDIO_U8) :: AudioFormat
pattern SDL_AUDIO_S8 = (#const SDL_AUDIO_S8) :: AudioFormat
pattern SDL_AUDIO_S16LE = (#const SDL_AUDIO_S16LE) :: AudioFormat
pattern SDL_AUDIO_S16BE = (#const SDL_AUDIO_S16BE) :: AudioFormat
pattern SDL_AUDIO_S16 = (#const SDL_AUDIO_S16) :: AudioFormat  -- System endianness
pattern SDL_AUDIO_S32LE = (#const SDL_AUDIO_S32LE) :: AudioFormat
pattern SDL_AUDIO_S32BE = (#const SDL_AUDIO_S32BE) :: AudioFormat
pattern SDL_AUDIO_S32 = (#const SDL_AUDIO_S32) :: AudioFormat  -- System endianness
pattern SDL_AUDIO_F32LE = (#const SDL_AUDIO_F32LE) :: AudioFormat
pattern SDL_AUDIO_F32BE = (#const SDL_AUDIO_F32BE) :: AudioFormat
pattern SDL_AUDIO_F32 = (#const SDL_AUDIO_F32) :: AudioFormat  -- System endianness

-- Default device constants
pattern SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK = (#const SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK) :: AudioDeviceID
pattern SDL_AUDIO_DEVICE_DEFAULT_RECORDING = (#const SDL_AUDIO_DEVICE_DEFAULT_RECORDING) :: AudioDeviceID

pattern SDL_BLENDMODE_NONE = (#const SDL_BLENDMODE_NONE) :: BlendMode
pattern SDL_BLENDMODE_BLEND = (#const SDL_BLENDMODE_BLEND) :: BlendMode
pattern SDL_BLENDMODE_ADD = (#const SDL_BLENDMODE_ADD) :: BlendMode
pattern SDL_BLENDMODE_MOD = (#const SDL_BLENDMODE_MOD) :: BlendMode

pattern SDL_BLENDOPERATION_ADD = (#const SDL_BLENDOPERATION_ADD) :: BlendOperation
pattern SDL_BLENDOPERATION_SUBTRACT = (#const SDL_BLENDOPERATION_SUBTRACT) :: BlendOperation
pattern SDL_BLENDOPERATION_REV_SUBTRACT = (#const SDL_BLENDOPERATION_REV_SUBTRACT) :: BlendOperation
pattern SDL_BLENDOPERATION_MINIMUM = (#const SDL_BLENDOPERATION_MINIMUM) :: BlendOperation
pattern SDL_BLENDOPERATION_MAXIMUM = (#const SDL_BLENDOPERATION_MAXIMUM) :: BlendOperation

pattern SDL_BLENDFACTOR_ZERO = (#const SDL_BLENDFACTOR_ZERO) :: BlendFactor
pattern SDL_BLENDFACTOR_ONE = (#const SDL_BLENDFACTOR_ONE) :: BlendFactor
pattern SDL_BLENDFACTOR_SRC_COLOR = (#const SDL_BLENDFACTOR_SRC_COLOR) :: BlendFactor
pattern SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR = (#const SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR) :: BlendFactor
pattern SDL_BLENDFACTOR_SRC_ALPHA = (#const SDL_BLENDFACTOR_SRC_ALPHA) :: BlendFactor
pattern SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA = (#const SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA) :: BlendFactor
pattern SDL_BLENDFACTOR_DST_COLOR = (#const SDL_BLENDFACTOR_DST_COLOR) :: BlendFactor
pattern SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR = (#const SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR) :: BlendFactor
pattern SDL_BLENDFACTOR_DST_ALPHA = (#const SDL_BLENDFACTOR_DST_ALPHA) :: BlendFactor
pattern SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA = (#const SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA) :: BlendFactor

pattern SDL_BYTEORDER = (#const SDL_BYTEORDER) :: Endian
pattern SDL_LIL_ENDIAN = (#const SDL_LIL_ENDIAN) :: Endian
pattern SDL_BIG_ENDIAN = (#const SDL_BIG_ENDIAN) :: Endian

pattern SDL_ADDEVENT = (#const SDL_ADDEVENT) :: EventAction
pattern SDL_PEEKEVENT = (#const SDL_PEEKEVENT) :: EventAction
pattern SDL_GETEVENT = (#const SDL_GETEVENT) :: EventAction

pattern SDL_GAMEPAD_AXIS_INVALID      <- GamepadAxis (#const SDL_GAMEPAD_AXIS_INVALID)      where SDL_GAMEPAD_AXIS_INVALID      = GamepadAxis (#const SDL_GAMEPAD_AXIS_INVALID)
pattern SDL_GAMEPAD_AXIS_LEFTX        <- GamepadAxis (#const SDL_GAMEPAD_AXIS_LEFTX)        where SDL_GAMEPAD_AXIS_LEFTX        = GamepadAxis (#const SDL_GAMEPAD_AXIS_LEFTX)
pattern SDL_GAMEPAD_AXIS_LEFTY        <- GamepadAxis (#const SDL_GAMEPAD_AXIS_LEFTY)        where SDL_GAMEPAD_AXIS_LEFTY        = GamepadAxis (#const SDL_GAMEPAD_AXIS_LEFTY)
pattern SDL_GAMEPAD_AXIS_RIGHTX       <- GamepadAxis (#const SDL_GAMEPAD_AXIS_RIGHTX)       where SDL_GAMEPAD_AXIS_RIGHTX       = GamepadAxis (#const SDL_GAMEPAD_AXIS_RIGHTX)
pattern SDL_GAMEPAD_AXIS_RIGHTY       <- GamepadAxis (#const SDL_GAMEPAD_AXIS_RIGHTY)       where SDL_GAMEPAD_AXIS_RIGHTY       = GamepadAxis (#const SDL_GAMEPAD_AXIS_RIGHTY)
pattern SDL_GAMEPAD_AXIS_LEFT_TRIGGER <- GamepadAxis (#const SDL_GAMEPAD_AXIS_LEFT_TRIGGER) where SDL_GAMEPAD_AXIS_LEFT_TRIGGER = GamepadAxis (#const SDL_GAMEPAD_AXIS_LEFT_TRIGGER)
pattern SDL_GAMEPAD_AXIS_RIGHT_TRIGGER<- GamepadAxis (#const SDL_GAMEPAD_AXIS_RIGHT_TRIGGER)where SDL_GAMEPAD_AXIS_RIGHT_TRIGGER= GamepadAxis (#const SDL_GAMEPAD_AXIS_RIGHT_TRIGGER)
pattern SDL_GAMEPAD_AXIS_COUNT        <- GamepadAxis (#const SDL_GAMEPAD_AXIS_COUNT)

pattern SDL_GAMEPAD_BUTTON_INVALID      <- GamepadButton (#const SDL_GAMEPAD_BUTTON_INVALID)      where SDL_GAMEPAD_BUTTON_INVALID      = GamepadButton (#const SDL_GAMEPAD_BUTTON_INVALID)
pattern SDL_GAMEPAD_BUTTON_SOUTH        <- GamepadButton (#const SDL_GAMEPAD_BUTTON_SOUTH)        where SDL_GAMEPAD_BUTTON_SOUTH        = GamepadButton (#const SDL_GAMEPAD_BUTTON_SOUTH)
pattern SDL_GAMEPAD_BUTTON_EAST         <- GamepadButton (#const SDL_GAMEPAD_BUTTON_EAST)         where SDL_GAMEPAD_BUTTON_EAST         = GamepadButton (#const SDL_GAMEPAD_BUTTON_EAST)
pattern SDL_GAMEPAD_BUTTON_WEST         <- GamepadButton (#const SDL_GAMEPAD_BUTTON_WEST)         where SDL_GAMEPAD_BUTTON_WEST         = GamepadButton (#const SDL_GAMEPAD_BUTTON_WEST)
pattern SDL_GAMEPAD_BUTTON_NORTH        <- GamepadButton (#const SDL_GAMEPAD_BUTTON_NORTH)        where SDL_GAMEPAD_BUTTON_NORTH        = GamepadButton (#const SDL_GAMEPAD_BUTTON_NORTH)
pattern SDL_GAMEPAD_BUTTON_BACK         <- GamepadButton (#const SDL_GAMEPAD_BUTTON_BACK)         where SDL_GAMEPAD_BUTTON_BACK         = GamepadButton (#const SDL_GAMEPAD_BUTTON_BACK)
pattern SDL_GAMEPAD_BUTTON_GUIDE        <- GamepadButton (#const SDL_GAMEPAD_BUTTON_GUIDE)        where SDL_GAMEPAD_BUTTON_GUIDE        = GamepadButton (#const SDL_GAMEPAD_BUTTON_GUIDE)
pattern SDL_GAMEPAD_BUTTON_START        <- GamepadButton (#const SDL_GAMEPAD_BUTTON_START)        where SDL_GAMEPAD_BUTTON_START        = GamepadButton (#const SDL_GAMEPAD_BUTTON_START)
pattern SDL_GAMEPAD_BUTTON_LEFT_STICK   <- GamepadButton (#const SDL_GAMEPAD_BUTTON_LEFT_STICK)   where SDL_GAMEPAD_BUTTON_LEFT_STICK   = GamepadButton (#const SDL_GAMEPAD_BUTTON_LEFT_STICK)
pattern SDL_GAMEPAD_BUTTON_RIGHT_STICK  <- GamepadButton (#const SDL_GAMEPAD_BUTTON_RIGHT_STICK)  where SDL_GAMEPAD_BUTTON_RIGHT_STICK  = GamepadButton (#const SDL_GAMEPAD_BUTTON_RIGHT_STICK)
pattern SDL_GAMEPAD_BUTTON_LEFT_SHOULDER<- GamepadButton (#const SDL_GAMEPAD_BUTTON_LEFT_SHOULDER)where SDL_GAMEPAD_BUTTON_LEFT_SHOULDER= GamepadButton (#const SDL_GAMEPAD_BUTTON_LEFT_SHOULDER)
pattern SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER<-GamepadButton (#const SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER)where SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER=GamepadButton (#const SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER)
pattern SDL_GAMEPAD_BUTTON_DPAD_UP      <- GamepadButton (#const SDL_GAMEPAD_BUTTON_DPAD_UP)      where SDL_GAMEPAD_BUTTON_DPAD_UP      = GamepadButton (#const SDL_GAMEPAD_BUTTON_DPAD_UP)
pattern SDL_GAMEPAD_BUTTON_DPAD_DOWN    <- GamepadButton (#const SDL_GAMEPAD_BUTTON_DPAD_DOWN)    where SDL_GAMEPAD_BUTTON_DPAD_DOWN    = GamepadButton (#const SDL_GAMEPAD_BUTTON_DPAD_DOWN)
pattern SDL_GAMEPAD_BUTTON_DPAD_LEFT    <- GamepadButton (#const SDL_GAMEPAD_BUTTON_DPAD_LEFT)    where SDL_GAMEPAD_BUTTON_DPAD_LEFT    = GamepadButton (#const SDL_GAMEPAD_BUTTON_DPAD_LEFT)
pattern SDL_GAMEPAD_BUTTON_DPAD_RIGHT   <- GamepadButton (#const SDL_GAMEPAD_BUTTON_DPAD_RIGHT)   where SDL_GAMEPAD_BUTTON_DPAD_RIGHT   = GamepadButton (#const SDL_GAMEPAD_BUTTON_DPAD_RIGHT)
pattern SDL_GAMEPAD_BUTTON_COUNT        <- GamepadButton (#const SDL_GAMEPAD_BUTTON_COUNT)        where SDL_GAMEPAD_BUTTON_COUNT        = GamepadButton (#const SDL_GAMEPAD_BUTTON_COUNT)

pattern SDL_GAMEPAD_TYPE_UNKNOWN = (#const SDL_GAMEPAD_TYPE_UNKNOWN) :: GamepadType
pattern SDL_GAMEPAD_TYPE_STANDARD = (#const SDL_GAMEPAD_TYPE_STANDARD) :: GamepadType
pattern SDL_GAMEPAD_TYPE_XBOX360 = (#const SDL_GAMEPAD_TYPE_XBOX360) :: GamepadType
pattern SDL_GAMEPAD_TYPE_XBOXONE = (#const SDL_GAMEPAD_TYPE_XBOXONE) :: GamepadType
pattern SDL_GAMEPAD_TYPE_PS3 = (#const SDL_GAMEPAD_TYPE_PS3) :: GamepadType
pattern SDL_GAMEPAD_TYPE_PS4 = (#const SDL_GAMEPAD_TYPE_PS4) :: GamepadType
pattern SDL_GAMEPAD_TYPE_PS5 = (#const SDL_GAMEPAD_TYPE_PS5) :: GamepadType
pattern SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_PRO = (#const SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_PRO) :: GamepadType
pattern SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_LEFT = (#const SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_LEFT) :: GamepadType
pattern SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_RIGHT = (#const SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_RIGHT) :: GamepadType
pattern SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_PAIR = (#const SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_PAIR) :: GamepadType
pattern SDL_GAMEPAD_TYPE_COUNT = (#const SDL_GAMEPAD_TYPE_COUNT) :: GamepadType

pattern SDL_GAMEPAD_BUTTON_LABEL_UNKNOWN = (#const SDL_GAMEPAD_BUTTON_LABEL_UNKNOWN) :: GamepadButtonLabel
pattern SDL_GAMEPAD_BUTTON_LABEL_A = (#const SDL_GAMEPAD_BUTTON_LABEL_A) :: GamepadButtonLabel
pattern SDL_GAMEPAD_BUTTON_LABEL_B = (#const SDL_GAMEPAD_BUTTON_LABEL_B) :: GamepadButtonLabel
pattern SDL_GAMEPAD_BUTTON_LABEL_X = (#const SDL_GAMEPAD_BUTTON_LABEL_X) :: GamepadButtonLabel
pattern SDL_GAMEPAD_BUTTON_LABEL_Y = (#const SDL_GAMEPAD_BUTTON_LABEL_Y) :: GamepadButtonLabel
pattern SDL_GAMEPAD_BUTTON_LABEL_CROSS = (#const SDL_GAMEPAD_BUTTON_LABEL_CROSS) :: GamepadButtonLabel
pattern SDL_GAMEPAD_BUTTON_LABEL_CIRCLE = (#const SDL_GAMEPAD_BUTTON_LABEL_CIRCLE) :: GamepadButtonLabel
pattern SDL_GAMEPAD_BUTTON_LABEL_SQUARE = (#const SDL_GAMEPAD_BUTTON_LABEL_SQUARE) :: GamepadButtonLabel
pattern SDL_GAMEPAD_BUTTON_LABEL_TRIANGLE = (#const SDL_GAMEPAD_BUTTON_LABEL_TRIANGLE) :: GamepadButtonLabel

pattern SDL_GL_RED_SIZE = (#const SDL_GL_RED_SIZE) :: GLAttr
pattern SDL_GL_GREEN_SIZE = (#const SDL_GL_GREEN_SIZE) :: GLAttr
pattern SDL_GL_BLUE_SIZE = (#const SDL_GL_BLUE_SIZE) :: GLAttr
pattern SDL_GL_ALPHA_SIZE = (#const SDL_GL_ALPHA_SIZE) :: GLAttr
pattern SDL_GL_BUFFER_SIZE = (#const SDL_GL_BUFFER_SIZE) :: GLAttr
pattern SDL_GL_DOUBLEBUFFER = (#const SDL_GL_DOUBLEBUFFER) :: GLAttr
pattern SDL_GL_DEPTH_SIZE = (#const SDL_GL_DEPTH_SIZE) :: GLAttr
pattern SDL_GL_STENCIL_SIZE = (#const SDL_GL_STENCIL_SIZE) :: GLAttr
pattern SDL_GL_ACCUM_RED_SIZE = (#const SDL_GL_ACCUM_RED_SIZE) :: GLAttr
pattern SDL_GL_ACCUM_GREEN_SIZE = (#const SDL_GL_ACCUM_GREEN_SIZE) :: GLAttr
pattern SDL_GL_ACCUM_BLUE_SIZE = (#const SDL_GL_ACCUM_BLUE_SIZE) :: GLAttr
pattern SDL_GL_ACCUM_ALPHA_SIZE = (#const SDL_GL_ACCUM_ALPHA_SIZE) :: GLAttr
pattern SDL_GL_STEREO = (#const SDL_GL_STEREO) :: GLAttr
pattern SDL_GL_MULTISAMPLEBUFFERS = (#const SDL_GL_MULTISAMPLEBUFFERS) :: GLAttr
pattern SDL_GL_MULTISAMPLESAMPLES = (#const SDL_GL_MULTISAMPLESAMPLES) :: GLAttr
pattern SDL_GL_ACCELERATED_VISUAL = (#const SDL_GL_ACCELERATED_VISUAL) :: GLAttr
pattern SDL_GL_RETAINED_BACKING = (#const SDL_GL_RETAINED_BACKING) :: GLAttr
pattern SDL_GL_CONTEXT_MAJOR_VERSION = (#const SDL_GL_CONTEXT_MAJOR_VERSION) :: GLAttr
pattern SDL_GL_CONTEXT_MINOR_VERSION = (#const SDL_GL_CONTEXT_MINOR_VERSION) :: GLAttr
pattern SDL_GL_CONTEXT_FLAGS = (#const SDL_GL_CONTEXT_FLAGS) :: GLAttr
pattern SDL_GL_CONTEXT_PROFILE_MASK = (#const SDL_GL_CONTEXT_PROFILE_MASK) :: GLAttr
pattern SDL_GL_SHARE_WITH_CURRENT_CONTEXT = (#const SDL_GL_SHARE_WITH_CURRENT_CONTEXT) :: GLAttr
pattern SDL_GL_FRAMEBUFFER_SRGB_CAPABLE = (#const SDL_GL_FRAMEBUFFER_SRGB_CAPABLE) :: GLAttr
pattern SDL_GL_CONTEXT_RELEASE_BEHAVIOR = (#const SDL_GL_CONTEXT_RELEASE_BEHAVIOR) :: GLAttr

pattern SDL_HINT_DEFAULT = (#const SDL_HINT_DEFAULT) :: HintPriority
pattern SDL_HINT_NORMAL = (#const SDL_HINT_NORMAL) :: HintPriority
pattern SDL_HINT_OVERRIDE = (#const SDL_HINT_OVERRIDE) :: HintPriority

pattern SDL_INIT_AUDIO = (#const SDL_INIT_AUDIO) :: InitFlag
pattern SDL_INIT_VIDEO = (#const SDL_INIT_VIDEO) :: InitFlag
pattern SDL_INIT_JOYSTICK = (#const SDL_INIT_JOYSTICK) :: InitFlag
pattern SDL_INIT_HAPTIC = (#const SDL_INIT_HAPTIC) :: InitFlag
pattern SDL_INIT_GAMEPAD = (#const SDL_INIT_GAMEPAD) :: InitFlag
pattern SDL_INIT_EVENTS = (#const SDL_INIT_EVENTS) :: InitFlag

pattern SDL_JOYSTICK_TYPE_UNKNOWN = (#const SDL_JOYSTICK_TYPE_UNKNOWN) :: JoystickType
pattern SDL_JOYSTICK_TYPE_GAMEPAD = (#const SDL_JOYSTICK_TYPE_GAMEPAD) :: JoystickType
pattern SDL_JOYSTICK_TYPE_WHEEL = (#const SDL_JOYSTICK_TYPE_WHEEL) :: JoystickType
pattern SDL_JOYSTICK_TYPE_ARCADE_STICK = (#const SDL_JOYSTICK_TYPE_ARCADE_STICK) :: JoystickType
pattern SDL_JOYSTICK_TYPE_FLIGHT_STICK = (#const SDL_JOYSTICK_TYPE_FLIGHT_STICK) :: JoystickType
pattern SDL_JOYSTICK_TYPE_DANCE_PAD = (#const SDL_JOYSTICK_TYPE_DANCE_PAD) :: JoystickType
pattern SDL_JOYSTICK_TYPE_GUITAR = (#const SDL_JOYSTICK_TYPE_GUITAR) :: JoystickType
pattern SDL_JOYSTICK_TYPE_DRUM_KIT = (#const SDL_JOYSTICK_TYPE_DRUM_KIT) :: JoystickType
pattern SDL_JOYSTICK_TYPE_ARCADE_PAD = (#const SDL_JOYSTICK_TYPE_ARCADE_PAD) :: JoystickType
pattern SDL_JOYSTICK_TYPE_THROTTLE = (#const SDL_JOYSTICK_TYPE_THROTTLE) :: JoystickType
pattern SDL_JOYSTICK_TYPE_COUNT = (#const SDL_JOYSTICK_TYPE_COUNT) :: JoystickType

pattern SDL_JOYSTICK_CONNECTION_INVALID = (#const SDL_JOYSTICK_CONNECTION_INVALID) :: JoystickConnectionState
pattern SDL_JOYSTICK_CONNECTION_UNKNOWN = (#const SDL_JOYSTICK_CONNECTION_UNKNOWN) :: JoystickConnectionState
pattern SDL_JOYSTICK_CONNECTION_WIRED = (#const SDL_JOYSTICK_CONNECTION_WIRED) :: JoystickConnectionState
pattern SDL_JOYSTICK_CONNECTION_WIRELESS = (#const SDL_JOYSTICK_CONNECTION_WIRELESS) :: JoystickConnectionState

pattern SDLK_UNKNOWN = (#const SDLK_UNKNOWN) :: Keycode
pattern SDLK_RETURN = (#const SDLK_RETURN) :: Keycode
pattern SDLK_ESCAPE = (#const SDLK_ESCAPE) :: Keycode
pattern SDLK_BACKSPACE = (#const SDLK_BACKSPACE) :: Keycode
pattern SDLK_TAB = (#const SDLK_TAB) :: Keycode
pattern SDLK_SPACE = (#const SDLK_SPACE) :: Keycode
pattern SDLK_EXCLAIM = (#const SDLK_EXCLAIM) :: Keycode
pattern SDLK_DBLAPOSTROPHE = (#const SDLK_DBLAPOSTROPHE) :: Keycode
pattern SDLK_HASH = (#const SDLK_HASH) :: Keycode
pattern SDLK_PERCENT = (#const SDLK_PERCENT) :: Keycode
pattern SDLK_DOLLAR = (#const SDLK_DOLLAR) :: Keycode
pattern SDLK_AMPERSAND = (#const SDLK_AMPERSAND) :: Keycode
pattern SDLK_APOSTROPHE = (#const SDLK_APOSTROPHE) :: Keycode
pattern SDLK_LEFTPAREN = (#const SDLK_LEFTPAREN) :: Keycode
pattern SDLK_RIGHTPAREN = (#const SDLK_RIGHTPAREN) :: Keycode
pattern SDLK_ASTERISK = (#const SDLK_ASTERISK) :: Keycode
pattern SDLK_PLUS = (#const SDLK_PLUS) :: Keycode
pattern SDLK_COMMA = (#const SDLK_COMMA) :: Keycode
pattern SDLK_MINUS = (#const SDLK_MINUS) :: Keycode
pattern SDLK_PERIOD = (#const SDLK_PERIOD) :: Keycode
pattern SDLK_SLASH = (#const SDLK_SLASH) :: Keycode
pattern SDLK_0 = (#const SDLK_0) :: Keycode
pattern SDLK_1 = (#const SDLK_1) :: Keycode
pattern SDLK_2 = (#const SDLK_2) :: Keycode
pattern SDLK_3 = (#const SDLK_3) :: Keycode
pattern SDLK_4 = (#const SDLK_4) :: Keycode
pattern SDLK_5 = (#const SDLK_5) :: Keycode
pattern SDLK_6 = (#const SDLK_6) :: Keycode
pattern SDLK_7 = (#const SDLK_7) :: Keycode
pattern SDLK_8 = (#const SDLK_8) :: Keycode
pattern SDLK_9 = (#const SDLK_9) :: Keycode
pattern SDLK_COLON = (#const SDLK_COLON) :: Keycode
pattern SDLK_SEMICOLON = (#const SDLK_SEMICOLON) :: Keycode
pattern SDLK_LESS = (#const SDLK_LESS) :: Keycode
pattern SDLK_EQUALS = (#const SDLK_EQUALS) :: Keycode
pattern SDLK_GREATER = (#const SDLK_GREATER) :: Keycode
pattern SDLK_QUESTION = (#const SDLK_QUESTION) :: Keycode
pattern SDLK_AT = (#const SDLK_AT) :: Keycode
pattern SDLK_LEFTBRACKET = (#const SDLK_LEFTBRACKET) :: Keycode
pattern SDLK_BACKSLASH = (#const SDLK_BACKSLASH) :: Keycode
pattern SDLK_RIGHTBRACKET = (#const SDLK_RIGHTBRACKET) :: Keycode
pattern SDLK_CARET = (#const SDLK_CARET) :: Keycode
pattern SDLK_UNDERSCORE = (#const SDLK_UNDERSCORE) :: Keycode
pattern SDLK_GRAVE = (#const SDLK_GRAVE) :: Keycode
pattern SDLK_A = (#const SDLK_A) :: Keycode
pattern SDLK_B = (#const SDLK_B) :: Keycode
pattern SDLK_C = (#const SDLK_C) :: Keycode
pattern SDLK_D = (#const SDLK_D) :: Keycode
pattern SDLK_E = (#const SDLK_E) :: Keycode
pattern SDLK_F = (#const SDLK_F) :: Keycode
pattern SDLK_G = (#const SDLK_G) :: Keycode
pattern SDLK_H = (#const SDLK_H) :: Keycode
pattern SDLK_I = (#const SDLK_I) :: Keycode
pattern SDLK_J = (#const SDLK_J) :: Keycode
pattern SDLK_K = (#const SDLK_K) :: Keycode
pattern SDLK_L = (#const SDLK_L) :: Keycode
pattern SDLK_M = (#const SDLK_M) :: Keycode
pattern SDLK_N = (#const SDLK_N) :: Keycode
pattern SDLK_O = (#const SDLK_O) :: Keycode
pattern SDLK_P = (#const SDLK_P) :: Keycode
pattern SDLK_Q = (#const SDLK_Q) :: Keycode
pattern SDLK_R = (#const SDLK_R) :: Keycode
pattern SDLK_S = (#const SDLK_S) :: Keycode
pattern SDLK_T = (#const SDLK_T) :: Keycode
pattern SDLK_U = (#const SDLK_U) :: Keycode
pattern SDLK_V = (#const SDLK_V) :: Keycode
pattern SDLK_W = (#const SDLK_W) :: Keycode
pattern SDLK_X = (#const SDLK_X) :: Keycode
pattern SDLK_Y = (#const SDLK_Y) :: Keycode
pattern SDLK_Z = (#const SDLK_Z) :: Keycode
pattern SDLK_CAPSLOCK = (#const SDLK_CAPSLOCK) :: Keycode
pattern SDLK_F1 = (#const SDLK_F1) :: Keycode
pattern SDLK_F2 = (#const SDLK_F2) :: Keycode
pattern SDLK_F3 = (#const SDLK_F3) :: Keycode
pattern SDLK_F4 = (#const SDLK_F4) :: Keycode
pattern SDLK_F5 = (#const SDLK_F5) :: Keycode
pattern SDLK_F6 = (#const SDLK_F6) :: Keycode
pattern SDLK_F7 = (#const SDLK_F7) :: Keycode
pattern SDLK_F8 = (#const SDLK_F8) :: Keycode
pattern SDLK_F9 = (#const SDLK_F9) :: Keycode
pattern SDLK_F10 = (#const SDLK_F10) :: Keycode
pattern SDLK_F11 = (#const SDLK_F11) :: Keycode
pattern SDLK_F12 = (#const SDLK_F12) :: Keycode
pattern SDLK_PRINTSCREEN = (#const SDLK_PRINTSCREEN) :: Keycode
pattern SDLK_SCROLLLOCK = (#const SDLK_SCROLLLOCK) :: Keycode
pattern SDLK_PAUSE = (#const SDLK_PAUSE) :: Keycode
pattern SDLK_INSERT = (#const SDLK_INSERT) :: Keycode
pattern SDLK_HOME = (#const SDLK_HOME) :: Keycode
pattern SDLK_PAGEUP = (#const SDLK_PAGEUP) :: Keycode
pattern SDLK_DELETE = (#const SDLK_DELETE) :: Keycode
pattern SDLK_END = (#const SDLK_END) :: Keycode
pattern SDLK_PAGEDOWN = (#const SDLK_PAGEDOWN) :: Keycode
pattern SDLK_RIGHT = (#const SDLK_RIGHT) :: Keycode
pattern SDLK_LEFT = (#const SDLK_LEFT) :: Keycode
pattern SDLK_DOWN = (#const SDLK_DOWN) :: Keycode
pattern SDLK_UP = (#const SDLK_UP) :: Keycode
pattern SDLK_NUMLOCKCLEAR = (#const SDLK_NUMLOCKCLEAR) :: Keycode
pattern SDLK_KP_DIVIDE = (#const SDLK_KP_DIVIDE) :: Keycode
pattern SDLK_KP_MULTIPLY = (#const SDLK_KP_MULTIPLY) :: Keycode
pattern SDLK_KP_MINUS = (#const SDLK_KP_MINUS) :: Keycode
pattern SDLK_KP_PLUS = (#const SDLK_KP_PLUS) :: Keycode
pattern SDLK_KP_ENTER = (#const SDLK_KP_ENTER) :: Keycode
pattern SDLK_KP_1 = (#const SDLK_KP_1) :: Keycode
pattern SDLK_KP_2 = (#const SDLK_KP_2) :: Keycode
pattern SDLK_KP_3 = (#const SDLK_KP_3) :: Keycode
pattern SDLK_KP_4 = (#const SDLK_KP_4) :: Keycode
pattern SDLK_KP_5 = (#const SDLK_KP_5) :: Keycode
pattern SDLK_KP_6 = (#const SDLK_KP_6) :: Keycode
pattern SDLK_KP_7 = (#const SDLK_KP_7) :: Keycode
pattern SDLK_KP_8 = (#const SDLK_KP_8) :: Keycode
pattern SDLK_KP_9 = (#const SDLK_KP_9) :: Keycode
pattern SDLK_KP_0 = (#const SDLK_KP_0) :: Keycode
pattern SDLK_KP_PERIOD = (#const SDLK_KP_PERIOD) :: Keycode
pattern SDLK_APPLICATION = (#const SDLK_APPLICATION) :: Keycode
pattern SDLK_POWER = (#const SDLK_POWER) :: Keycode
pattern SDLK_KP_EQUALS = (#const SDLK_KP_EQUALS) :: Keycode
pattern SDLK_F13 = (#const SDLK_F13) :: Keycode
pattern SDLK_F14 = (#const SDLK_F14) :: Keycode
pattern SDLK_F15 = (#const SDLK_F15) :: Keycode
pattern SDLK_F16 = (#const SDLK_F16) :: Keycode
pattern SDLK_F17 = (#const SDLK_F17) :: Keycode
pattern SDLK_F18 = (#const SDLK_F18) :: Keycode
pattern SDLK_F19 = (#const SDLK_F19) :: Keycode
pattern SDLK_F20 = (#const SDLK_F20) :: Keycode
pattern SDLK_F21 = (#const SDLK_F21) :: Keycode
pattern SDLK_F22 = (#const SDLK_F22) :: Keycode
pattern SDLK_F23 = (#const SDLK_F23) :: Keycode
pattern SDLK_F24 = (#const SDLK_F24) :: Keycode
pattern SDLK_EXECUTE = (#const SDLK_EXECUTE) :: Keycode
pattern SDLK_HELP = (#const SDLK_HELP) :: Keycode
pattern SDLK_MENU = (#const SDLK_MENU) :: Keycode
pattern SDLK_SELECT = (#const SDLK_SELECT) :: Keycode
pattern SDLK_STOP = (#const SDLK_STOP) :: Keycode
pattern SDLK_AGAIN = (#const SDLK_AGAIN) :: Keycode
pattern SDLK_UNDO = (#const SDLK_UNDO) :: Keycode
pattern SDLK_CUT = (#const SDLK_CUT) :: Keycode
pattern SDLK_COPY = (#const SDLK_COPY) :: Keycode
pattern SDLK_PASTE = (#const SDLK_PASTE) :: Keycode
pattern SDLK_FIND = (#const SDLK_FIND) :: Keycode
pattern SDLK_MUTE = (#const SDLK_MUTE) :: Keycode
pattern SDLK_VOLUMEUP = (#const SDLK_VOLUMEUP) :: Keycode
pattern SDLK_VOLUMEDOWN = (#const SDLK_VOLUMEDOWN) :: Keycode
pattern SDLK_KP_COMMA = (#const SDLK_KP_COMMA) :: Keycode
pattern SDLK_KP_EQUALSAS400 = (#const SDLK_KP_EQUALSAS400) :: Keycode
pattern SDLK_ALTERASE = (#const SDLK_ALTERASE) :: Keycode
pattern SDLK_SYSREQ = (#const SDLK_SYSREQ) :: Keycode
pattern SDLK_CANCEL = (#const SDLK_CANCEL) :: Keycode
pattern SDLK_CLEAR = (#const SDLK_CLEAR) :: Keycode
pattern SDLK_PRIOR = (#const SDLK_PRIOR) :: Keycode
pattern SDLK_RETURN2 = (#const SDLK_RETURN2) :: Keycode
pattern SDLK_SEPARATOR = (#const SDLK_SEPARATOR) :: Keycode
pattern SDLK_OUT = (#const SDLK_OUT) :: Keycode
pattern SDLK_OPER = (#const SDLK_OPER) :: Keycode
pattern SDLK_CLEARAGAIN = (#const SDLK_CLEARAGAIN) :: Keycode
pattern SDLK_CRSEL = (#const SDLK_CRSEL) :: Keycode
pattern SDLK_EXSEL = (#const SDLK_EXSEL) :: Keycode
pattern SDLK_KP_00 = (#const SDLK_KP_00) :: Keycode
pattern SDLK_KP_000 = (#const SDLK_KP_000) :: Keycode
pattern SDLK_THOUSANDSSEPARATOR = (#const SDLK_THOUSANDSSEPARATOR) :: Keycode
pattern SDLK_DECIMALSEPARATOR = (#const SDLK_DECIMALSEPARATOR) :: Keycode
pattern SDLK_CURRENCYUNIT = (#const SDLK_CURRENCYUNIT) :: Keycode
pattern SDLK_CURRENCYSUBUNIT = (#const SDLK_CURRENCYSUBUNIT) :: Keycode
pattern SDLK_KP_LEFTPAREN = (#const SDLK_KP_LEFTPAREN) :: Keycode
pattern SDLK_KP_RIGHTPAREN = (#const SDLK_KP_RIGHTPAREN) :: Keycode
pattern SDLK_KP_LEFTBRACE = (#const SDLK_KP_LEFTBRACE) :: Keycode
pattern SDLK_KP_RIGHTBRACE = (#const SDLK_KP_RIGHTBRACE) :: Keycode
pattern SDLK_KP_TAB = (#const SDLK_KP_TAB) :: Keycode
pattern SDLK_KP_BACKSPACE = (#const SDLK_KP_BACKSPACE) :: Keycode
pattern SDLK_KP_A = (#const SDLK_KP_A) :: Keycode
pattern SDLK_KP_B = (#const SDLK_KP_B) :: Keycode
pattern SDLK_KP_C = (#const SDLK_KP_C) :: Keycode
pattern SDLK_KP_D = (#const SDLK_KP_D) :: Keycode
pattern SDLK_KP_E = (#const SDLK_KP_E) :: Keycode
pattern SDLK_KP_F = (#const SDLK_KP_F) :: Keycode
pattern SDLK_KP_XOR = (#const SDLK_KP_XOR) :: Keycode
pattern SDLK_KP_POWER = (#const SDLK_KP_POWER) :: Keycode
pattern SDLK_KP_PERCENT = (#const SDLK_KP_PERCENT) :: Keycode
pattern SDLK_KP_LESS = (#const SDLK_KP_LESS) :: Keycode
pattern SDLK_KP_GREATER = (#const SDLK_KP_GREATER) :: Keycode
pattern SDLK_KP_AMPERSAND = (#const SDLK_KP_AMPERSAND) :: Keycode
pattern SDLK_KP_DBLAMPERSAND = (#const SDLK_KP_DBLAMPERSAND) :: Keycode
pattern SDLK_KP_VERTICALBAR = (#const SDLK_KP_VERTICALBAR) :: Keycode
pattern SDLK_KP_DBLVERTICALBAR = (#const SDLK_KP_DBLVERTICALBAR) :: Keycode
pattern SDLK_KP_COLON = (#const SDLK_KP_COLON) :: Keycode
pattern SDLK_KP_HASH = (#const SDLK_KP_HASH) :: Keycode
pattern SDLK_KP_SPACE = (#const SDLK_KP_SPACE) :: Keycode
pattern SDLK_KP_AT = (#const SDLK_KP_AT) :: Keycode
pattern SDLK_KP_EXCLAM = (#const SDLK_KP_EXCLAM) :: Keycode
pattern SDLK_KP_MEMSTORE = (#const SDLK_KP_MEMSTORE) :: Keycode
pattern SDLK_KP_MEMRECALL = (#const SDLK_KP_MEMRECALL) :: Keycode
pattern SDLK_KP_MEMCLEAR = (#const SDLK_KP_MEMCLEAR) :: Keycode
pattern SDLK_KP_MEMADD = (#const SDLK_KP_MEMADD) :: Keycode
pattern SDLK_KP_MEMSUBTRACT = (#const SDLK_KP_MEMSUBTRACT) :: Keycode
pattern SDLK_KP_MEMMULTIPLY = (#const SDLK_KP_MEMMULTIPLY) :: Keycode
pattern SDLK_KP_MEMDIVIDE = (#const SDLK_KP_MEMDIVIDE) :: Keycode
pattern SDLK_KP_PLUSMINUS = (#const SDLK_KP_PLUSMINUS) :: Keycode
pattern SDLK_KP_CLEAR = (#const SDLK_KP_CLEAR) :: Keycode
pattern SDLK_KP_CLEARENTRY = (#const SDLK_KP_CLEARENTRY) :: Keycode
pattern SDLK_KP_BINARY = (#const SDLK_KP_BINARY) :: Keycode
pattern SDLK_KP_OCTAL = (#const SDLK_KP_OCTAL) :: Keycode
pattern SDLK_KP_DECIMAL = (#const SDLK_KP_DECIMAL) :: Keycode
pattern SDLK_KP_HEXADECIMAL = (#const SDLK_KP_HEXADECIMAL) :: Keycode
pattern SDLK_LCTRL = (#const SDLK_LCTRL) :: Keycode
pattern SDLK_LSHIFT = (#const SDLK_LSHIFT) :: Keycode
pattern SDLK_LALT = (#const SDLK_LALT) :: Keycode
pattern SDLK_LGUI = (#const SDLK_LGUI) :: Keycode
pattern SDLK_RCTRL = (#const SDLK_RCTRL) :: Keycode
pattern SDLK_RSHIFT = (#const SDLK_RSHIFT) :: Keycode
pattern SDLK_RALT = (#const SDLK_RALT) :: Keycode
pattern SDLK_RGUI = (#const SDLK_RGUI) :: Keycode
pattern SDLK_MODE = (#const SDLK_MODE) :: Keycode
pattern SDLK_MEDIA_NEXT_TRACK = (#const SDLK_MEDIA_NEXT_TRACK) :: Keycode
pattern SDLK_MEDIA_PREVIOUS_TRACK = (#const SDLK_MEDIA_PREVIOUS_TRACK) :: Keycode
pattern SDLK_MEDIA_STOP = (#const SDLK_MEDIA_STOP) :: Keycode
pattern SDLK_MEDIA_PLAY = (#const SDLK_MEDIA_PLAY) :: Keycode
pattern SDLK_MEDIA_SELECT = (#const SDLK_MEDIA_SELECT) :: Keycode
pattern SDLK_AC_SEARCH = (#const SDLK_AC_SEARCH) :: Keycode
pattern SDLK_AC_HOME = (#const SDLK_AC_HOME) :: Keycode
pattern SDLK_AC_BACK = (#const SDLK_AC_BACK) :: Keycode
pattern SDLK_AC_FORWARD = (#const SDLK_AC_FORWARD) :: Keycode
pattern SDLK_AC_STOP = (#const SDLK_AC_STOP) :: Keycode
pattern SDLK_AC_REFRESH = (#const SDLK_AC_REFRESH) :: Keycode
pattern SDLK_AC_BOOKMARKS = (#const SDLK_AC_BOOKMARKS) :: Keycode
pattern SDLK_MEDIA_EJECT = (#const SDLK_MEDIA_EJECT) :: Keycode
pattern SDLK_SLEEP = (#const SDLK_SLEEP) :: Keycode

pattern SDL_KMOD_NONE = (#const SDL_KMOD_NONE)
pattern SDL_KMOD_LSHIFT = (#const SDL_KMOD_LSHIFT)
pattern SDL_KMOD_RSHIFT = (#const SDL_KMOD_RSHIFT)
pattern SDL_KMOD_SHIFT = (#const SDL_KMOD_SHIFT)
pattern SDL_KMOD_LCTRL = (#const SDL_KMOD_LCTRL)
pattern SDL_KMOD_RCTRL = (#const SDL_KMOD_RCTRL)
pattern SDL_KMOD_CTRL = (#const SDL_KMOD_CTRL)
pattern SDL_KMOD_LALT = (#const SDL_KMOD_LALT)
pattern SDL_KMOD_RALT = (#const SDL_KMOD_RALT)
pattern SDL_KMOD_ALT = (#const SDL_KMOD_ALT)
pattern SDL_KMOD_LGUI = (#const SDL_KMOD_LGUI)
pattern SDL_KMOD_RGUI = (#const SDL_KMOD_RGUI)
pattern SDL_KMOD_GUI = (#const SDL_KMOD_GUI)
pattern SDL_KMOD_NUM = (#const SDL_KMOD_NUM)
pattern SDL_KMOD_CAPS = (#const SDL_KMOD_CAPS)
pattern SDL_KMOD_MODE = (#const SDL_KMOD_MODE)

pattern SDL_LOG_PRIORITY_VERBOSE = (#const SDL_LOG_PRIORITY_VERBOSE) :: LogPriority
pattern SDL_LOG_PRIORITY_DEBUG = (#const SDL_LOG_PRIORITY_DEBUG) :: LogPriority
pattern SDL_LOG_PRIORITY_INFO = (#const SDL_LOG_PRIORITY_INFO) :: LogPriority
pattern SDL_LOG_PRIORITY_WARN = (#const SDL_LOG_PRIORITY_WARN) :: LogPriority
pattern SDL_LOG_PRIORITY_ERROR = (#const SDL_LOG_PRIORITY_ERROR) :: LogPriority
pattern SDL_LOG_PRIORITY_CRITICAL = (#const SDL_LOG_PRIORITY_CRITICAL) :: LogPriority
pattern SDL_LOG_PRIORITY_COUNT = (#const SDL_LOG_PRIORITY_COUNT) :: LogPriority

pattern SDL_POWERSTATE_ERROR = (#const SDL_POWERSTATE_ERROR) :: PowerState
pattern SDL_POWERSTATE_UNKNOWN = (#const SDL_POWERSTATE_UNKNOWN) :: PowerState
pattern SDL_POWERSTATE_ON_BATTERY = (#const SDL_POWERSTATE_ON_BATTERY) :: PowerState
pattern SDL_POWERSTATE_NO_BATTERY = (#const SDL_POWERSTATE_NO_BATTERY) :: PowerState
pattern SDL_POWERSTATE_CHARGING = (#const SDL_POWERSTATE_CHARGING) :: PowerState
pattern SDL_POWERSTATE_CHARGED = (#const SDL_POWERSTATE_CHARGED) :: PowerState

pattern SDL_FLIP_NONE = (#const SDL_FLIP_NONE) :: FlipMode
pattern SDL_FLIP_HORIZONTAL = (#const SDL_FLIP_HORIZONTAL) :: FlipMode
pattern SDL_FLIP_VERTICAL = (#const SDL_FLIP_VERTICAL) :: FlipMode

pattern SDL_LOGICAL_PRESENTATION_DISABLED     = (#const SDL_LOGICAL_PRESENTATION_DISABLED) :: RendererLogicalPresentation
pattern SDL_LOGICAL_PRESENTATION_STRETCH      = (#const SDL_LOGICAL_PRESENTATION_STRETCH) :: RendererLogicalPresentation
pattern SDL_LOGICAL_PRESENTATION_LETTERBOX    = (#const SDL_LOGICAL_PRESENTATION_LETTERBOX) :: RendererLogicalPresentation
pattern SDL_LOGICAL_PRESENTATION_OVERSCAN     = (#const SDL_LOGICAL_PRESENTATION_OVERSCAN) :: RendererLogicalPresentation
pattern SDL_LOGICAL_PRESENTATION_INTEGER_SCALE = (#const SDL_LOGICAL_PRESENTATION_INTEGER_SCALE) :: RendererLogicalPresentation

pattern SDL_SCALEMODE_NEAREST = (#const SDL_SCALEMODE_NEAREST) :: ScaleMode
pattern SDL_SCALEMODE_LINEAR  = (#const SDL_SCALEMODE_LINEAR) :: ScaleMode

pattern SDL_SCANCODE_UNKNOWN = (#const SDL_SCANCODE_UNKNOWN) :: Scancode
pattern SDL_SCANCODE_A = (#const SDL_SCANCODE_A) :: Scancode
pattern SDL_SCANCODE_B = (#const SDL_SCANCODE_B) :: Scancode
pattern SDL_SCANCODE_C = (#const SDL_SCANCODE_C) :: Scancode
pattern SDL_SCANCODE_D = (#const SDL_SCANCODE_D) :: Scancode
pattern SDL_SCANCODE_E = (#const SDL_SCANCODE_E) :: Scancode
pattern SDL_SCANCODE_F = (#const SDL_SCANCODE_F) :: Scancode
pattern SDL_SCANCODE_G = (#const SDL_SCANCODE_G) :: Scancode
pattern SDL_SCANCODE_H = (#const SDL_SCANCODE_H) :: Scancode
pattern SDL_SCANCODE_I = (#const SDL_SCANCODE_I) :: Scancode
pattern SDL_SCANCODE_J = (#const SDL_SCANCODE_J) :: Scancode
pattern SDL_SCANCODE_K = (#const SDL_SCANCODE_K) :: Scancode
pattern SDL_SCANCODE_L = (#const SDL_SCANCODE_L) :: Scancode
pattern SDL_SCANCODE_M = (#const SDL_SCANCODE_M) :: Scancode
pattern SDL_SCANCODE_N = (#const SDL_SCANCODE_N) :: Scancode
pattern SDL_SCANCODE_O = (#const SDL_SCANCODE_O) :: Scancode
pattern SDL_SCANCODE_P = (#const SDL_SCANCODE_P) :: Scancode
pattern SDL_SCANCODE_Q = (#const SDL_SCANCODE_Q) :: Scancode
pattern SDL_SCANCODE_R = (#const SDL_SCANCODE_R) :: Scancode
pattern SDL_SCANCODE_S = (#const SDL_SCANCODE_S) :: Scancode
pattern SDL_SCANCODE_T = (#const SDL_SCANCODE_T) :: Scancode
pattern SDL_SCANCODE_U = (#const SDL_SCANCODE_U) :: Scancode
pattern SDL_SCANCODE_V = (#const SDL_SCANCODE_V) :: Scancode
pattern SDL_SCANCODE_W = (#const SDL_SCANCODE_W) :: Scancode
pattern SDL_SCANCODE_X = (#const SDL_SCANCODE_X) :: Scancode
pattern SDL_SCANCODE_Y = (#const SDL_SCANCODE_Y) :: Scancode
pattern SDL_SCANCODE_Z = (#const SDL_SCANCODE_Z) :: Scancode
pattern SDL_SCANCODE_1 = (#const SDL_SCANCODE_1) :: Scancode
pattern SDL_SCANCODE_2 = (#const SDL_SCANCODE_2) :: Scancode
pattern SDL_SCANCODE_3 = (#const SDL_SCANCODE_3) :: Scancode
pattern SDL_SCANCODE_4 = (#const SDL_SCANCODE_4) :: Scancode
pattern SDL_SCANCODE_5 = (#const SDL_SCANCODE_5) :: Scancode
pattern SDL_SCANCODE_6 = (#const SDL_SCANCODE_6) :: Scancode
pattern SDL_SCANCODE_7 = (#const SDL_SCANCODE_7) :: Scancode
pattern SDL_SCANCODE_8 = (#const SDL_SCANCODE_8) :: Scancode
pattern SDL_SCANCODE_9 = (#const SDL_SCANCODE_9) :: Scancode
pattern SDL_SCANCODE_0 = (#const SDL_SCANCODE_0) :: Scancode
pattern SDL_SCANCODE_RETURN = (#const SDL_SCANCODE_RETURN) :: Scancode
pattern SDL_SCANCODE_ESCAPE = (#const SDL_SCANCODE_ESCAPE) :: Scancode
pattern SDL_SCANCODE_BACKSPACE = (#const SDL_SCANCODE_BACKSPACE) :: Scancode
pattern SDL_SCANCODE_TAB = (#const SDL_SCANCODE_TAB) :: Scancode
pattern SDL_SCANCODE_SPACE = (#const SDL_SCANCODE_SPACE) :: Scancode
pattern SDL_SCANCODE_MINUS = (#const SDL_SCANCODE_MINUS) :: Scancode
pattern SDL_SCANCODE_EQUALS = (#const SDL_SCANCODE_EQUALS) :: Scancode
pattern SDL_SCANCODE_LEFTBRACKET = (#const SDL_SCANCODE_LEFTBRACKET) :: Scancode
pattern SDL_SCANCODE_RIGHTBRACKET = (#const SDL_SCANCODE_RIGHTBRACKET) :: Scancode
pattern SDL_SCANCODE_BACKSLASH = (#const SDL_SCANCODE_BACKSLASH) :: Scancode
pattern SDL_SCANCODE_NONUSHASH = (#const SDL_SCANCODE_NONUSHASH) :: Scancode
pattern SDL_SCANCODE_SEMICOLON = (#const SDL_SCANCODE_SEMICOLON) :: Scancode
pattern SDL_SCANCODE_APOSTROPHE = (#const SDL_SCANCODE_APOSTROPHE) :: Scancode
pattern SDL_SCANCODE_GRAVE = (#const SDL_SCANCODE_GRAVE) :: Scancode
pattern SDL_SCANCODE_COMMA = (#const SDL_SCANCODE_COMMA) :: Scancode
pattern SDL_SCANCODE_PERIOD = (#const SDL_SCANCODE_PERIOD) :: Scancode
pattern SDL_SCANCODE_SLASH = (#const SDL_SCANCODE_SLASH) :: Scancode
pattern SDL_SCANCODE_CAPSLOCK = (#const SDL_SCANCODE_CAPSLOCK) :: Scancode
pattern SDL_SCANCODE_F1 = (#const SDL_SCANCODE_F1) :: Scancode
pattern SDL_SCANCODE_F2 = (#const SDL_SCANCODE_F2) :: Scancode
pattern SDL_SCANCODE_F3 = (#const SDL_SCANCODE_F3) :: Scancode
pattern SDL_SCANCODE_F4 = (#const SDL_SCANCODE_F4) :: Scancode
pattern SDL_SCANCODE_F5 = (#const SDL_SCANCODE_F5) :: Scancode
pattern SDL_SCANCODE_F6 = (#const SDL_SCANCODE_F6) :: Scancode
pattern SDL_SCANCODE_F7 = (#const SDL_SCANCODE_F7) :: Scancode
pattern SDL_SCANCODE_F8 = (#const SDL_SCANCODE_F8) :: Scancode
pattern SDL_SCANCODE_F9 = (#const SDL_SCANCODE_F9) :: Scancode
pattern SDL_SCANCODE_F10 = (#const SDL_SCANCODE_F10) :: Scancode
pattern SDL_SCANCODE_F11 = (#const SDL_SCANCODE_F11) :: Scancode
pattern SDL_SCANCODE_F12 = (#const SDL_SCANCODE_F12) :: Scancode
pattern SDL_SCANCODE_PRINTSCREEN = (#const SDL_SCANCODE_PRINTSCREEN) :: Scancode
pattern SDL_SCANCODE_SCROLLLOCK = (#const SDL_SCANCODE_SCROLLLOCK) :: Scancode
pattern SDL_SCANCODE_PAUSE = (#const SDL_SCANCODE_PAUSE) :: Scancode
pattern SDL_SCANCODE_INSERT = (#const SDL_SCANCODE_INSERT) :: Scancode
pattern SDL_SCANCODE_HOME = (#const SDL_SCANCODE_HOME) :: Scancode
pattern SDL_SCANCODE_PAGEUP = (#const SDL_SCANCODE_PAGEUP) :: Scancode
pattern SDL_SCANCODE_DELETE = (#const SDL_SCANCODE_DELETE) :: Scancode
pattern SDL_SCANCODE_END = (#const SDL_SCANCODE_END) :: Scancode
pattern SDL_SCANCODE_PAGEDOWN = (#const SDL_SCANCODE_PAGEDOWN) :: Scancode
pattern SDL_SCANCODE_RIGHT = (#const SDL_SCANCODE_RIGHT) :: Scancode
pattern SDL_SCANCODE_LEFT = (#const SDL_SCANCODE_LEFT) :: Scancode
pattern SDL_SCANCODE_DOWN = (#const SDL_SCANCODE_DOWN) :: Scancode
pattern SDL_SCANCODE_UP = (#const SDL_SCANCODE_UP) :: Scancode
pattern SDL_SCANCODE_NUMLOCKCLEAR = (#const SDL_SCANCODE_NUMLOCKCLEAR) :: Scancode
pattern SDL_SCANCODE_KP_DIVIDE = (#const SDL_SCANCODE_KP_DIVIDE) :: Scancode
pattern SDL_SCANCODE_KP_MULTIPLY = (#const SDL_SCANCODE_KP_MULTIPLY) :: Scancode
pattern SDL_SCANCODE_KP_MINUS = (#const SDL_SCANCODE_KP_MINUS) :: Scancode
pattern SDL_SCANCODE_KP_PLUS = (#const SDL_SCANCODE_KP_PLUS) :: Scancode
pattern SDL_SCANCODE_KP_ENTER = (#const SDL_SCANCODE_KP_ENTER) :: Scancode
pattern SDL_SCANCODE_KP_1 = (#const SDL_SCANCODE_KP_1) :: Scancode
pattern SDL_SCANCODE_KP_2 = (#const SDL_SCANCODE_KP_2) :: Scancode
pattern SDL_SCANCODE_KP_3 = (#const SDL_SCANCODE_KP_3) :: Scancode
pattern SDL_SCANCODE_KP_4 = (#const SDL_SCANCODE_KP_4) :: Scancode
pattern SDL_SCANCODE_KP_5 = (#const SDL_SCANCODE_KP_5) :: Scancode
pattern SDL_SCANCODE_KP_6 = (#const SDL_SCANCODE_KP_6) :: Scancode
pattern SDL_SCANCODE_KP_7 = (#const SDL_SCANCODE_KP_7) :: Scancode
pattern SDL_SCANCODE_KP_8 = (#const SDL_SCANCODE_KP_8) :: Scancode
pattern SDL_SCANCODE_KP_9 = (#const SDL_SCANCODE_KP_9) :: Scancode
pattern SDL_SCANCODE_KP_0 = (#const SDL_SCANCODE_KP_0) :: Scancode
pattern SDL_SCANCODE_KP_PERIOD = (#const SDL_SCANCODE_KP_PERIOD) :: Scancode
pattern SDL_SCANCODE_NONUSBACKSLASH = (#const SDL_SCANCODE_NONUSBACKSLASH) :: Scancode
pattern SDL_SCANCODE_APPLICATION = (#const SDL_SCANCODE_APPLICATION) :: Scancode
pattern SDL_SCANCODE_POWER = (#const SDL_SCANCODE_POWER) :: Scancode
pattern SDL_SCANCODE_KP_EQUALS = (#const SDL_SCANCODE_KP_EQUALS) :: Scancode
pattern SDL_SCANCODE_F13 = (#const SDL_SCANCODE_F13) :: Scancode
pattern SDL_SCANCODE_F14 = (#const SDL_SCANCODE_F14) :: Scancode
pattern SDL_SCANCODE_F15 = (#const SDL_SCANCODE_F15) :: Scancode
pattern SDL_SCANCODE_F16 = (#const SDL_SCANCODE_F16) :: Scancode
pattern SDL_SCANCODE_F17 = (#const SDL_SCANCODE_F17) :: Scancode
pattern SDL_SCANCODE_F18 = (#const SDL_SCANCODE_F18) :: Scancode
pattern SDL_SCANCODE_F19 = (#const SDL_SCANCODE_F19) :: Scancode
pattern SDL_SCANCODE_F20 = (#const SDL_SCANCODE_F20) :: Scancode
pattern SDL_SCANCODE_F21 = (#const SDL_SCANCODE_F21) :: Scancode
pattern SDL_SCANCODE_F22 = (#const SDL_SCANCODE_F22) :: Scancode
pattern SDL_SCANCODE_F23 = (#const SDL_SCANCODE_F23) :: Scancode
pattern SDL_SCANCODE_F24 = (#const SDL_SCANCODE_F24) :: Scancode
pattern SDL_SCANCODE_EXECUTE = (#const SDL_SCANCODE_EXECUTE) :: Scancode
pattern SDL_SCANCODE_HELP = (#const SDL_SCANCODE_HELP) :: Scancode
pattern SDL_SCANCODE_MENU = (#const SDL_SCANCODE_MENU) :: Scancode
pattern SDL_SCANCODE_SELECT = (#const SDL_SCANCODE_SELECT) :: Scancode
pattern SDL_SCANCODE_STOP = (#const SDL_SCANCODE_STOP) :: Scancode
pattern SDL_SCANCODE_AGAIN = (#const SDL_SCANCODE_AGAIN) :: Scancode
pattern SDL_SCANCODE_UNDO = (#const SDL_SCANCODE_UNDO) :: Scancode
pattern SDL_SCANCODE_CUT = (#const SDL_SCANCODE_CUT) :: Scancode
pattern SDL_SCANCODE_COPY = (#const SDL_SCANCODE_COPY) :: Scancode
pattern SDL_SCANCODE_PASTE = (#const SDL_SCANCODE_PASTE) :: Scancode
pattern SDL_SCANCODE_FIND = (#const SDL_SCANCODE_FIND) :: Scancode
pattern SDL_SCANCODE_MUTE = (#const SDL_SCANCODE_MUTE) :: Scancode
pattern SDL_SCANCODE_VOLUMEUP = (#const SDL_SCANCODE_VOLUMEUP) :: Scancode
pattern SDL_SCANCODE_VOLUMEDOWN = (#const SDL_SCANCODE_VOLUMEDOWN) :: Scancode
pattern SDL_SCANCODE_KP_COMMA = (#const SDL_SCANCODE_KP_COMMA) :: Scancode
pattern SDL_SCANCODE_KP_EQUALSAS400 = (#const SDL_SCANCODE_KP_EQUALSAS400) :: Scancode
pattern SDL_SCANCODE_INTERNATIONAL1 = (#const SDL_SCANCODE_INTERNATIONAL1) :: Scancode
pattern SDL_SCANCODE_INTERNATIONAL2 = (#const SDL_SCANCODE_INTERNATIONAL2) :: Scancode
pattern SDL_SCANCODE_INTERNATIONAL3 = (#const SDL_SCANCODE_INTERNATIONAL3) :: Scancode
pattern SDL_SCANCODE_INTERNATIONAL4 = (#const SDL_SCANCODE_INTERNATIONAL4) :: Scancode
pattern SDL_SCANCODE_INTERNATIONAL5 = (#const SDL_SCANCODE_INTERNATIONAL5) :: Scancode
pattern SDL_SCANCODE_INTERNATIONAL6 = (#const SDL_SCANCODE_INTERNATIONAL6) :: Scancode
pattern SDL_SCANCODE_INTERNATIONAL7 = (#const SDL_SCANCODE_INTERNATIONAL7) :: Scancode
pattern SDL_SCANCODE_INTERNATIONAL8 = (#const SDL_SCANCODE_INTERNATIONAL8) :: Scancode
pattern SDL_SCANCODE_INTERNATIONAL9 = (#const SDL_SCANCODE_INTERNATIONAL9) :: Scancode
pattern SDL_SCANCODE_LANG1 = (#const SDL_SCANCODE_LANG1) :: Scancode
pattern SDL_SCANCODE_LANG2 = (#const SDL_SCANCODE_LANG2) :: Scancode
pattern SDL_SCANCODE_LANG3 = (#const SDL_SCANCODE_LANG3) :: Scancode
pattern SDL_SCANCODE_LANG4 = (#const SDL_SCANCODE_LANG4) :: Scancode
pattern SDL_SCANCODE_LANG5 = (#const SDL_SCANCODE_LANG5) :: Scancode
pattern SDL_SCANCODE_LANG6 = (#const SDL_SCANCODE_LANG6) :: Scancode
pattern SDL_SCANCODE_LANG7 = (#const SDL_SCANCODE_LANG7) :: Scancode
pattern SDL_SCANCODE_LANG8 = (#const SDL_SCANCODE_LANG8) :: Scancode
pattern SDL_SCANCODE_LANG9 = (#const SDL_SCANCODE_LANG9) :: Scancode
pattern SDL_SCANCODE_ALTERASE = (#const SDL_SCANCODE_ALTERASE) :: Scancode
pattern SDL_SCANCODE_SYSREQ = (#const SDL_SCANCODE_SYSREQ) :: Scancode
pattern SDL_SCANCODE_CANCEL = (#const SDL_SCANCODE_CANCEL) :: Scancode
pattern SDL_SCANCODE_CLEAR = (#const SDL_SCANCODE_CLEAR) :: Scancode
pattern SDL_SCANCODE_PRIOR = (#const SDL_SCANCODE_PRIOR) :: Scancode
pattern SDL_SCANCODE_RETURN2 = (#const SDL_SCANCODE_RETURN2) :: Scancode
pattern SDL_SCANCODE_SEPARATOR = (#const SDL_SCANCODE_SEPARATOR) :: Scancode
pattern SDL_SCANCODE_OUT = (#const SDL_SCANCODE_OUT) :: Scancode
pattern SDL_SCANCODE_OPER = (#const SDL_SCANCODE_OPER) :: Scancode
pattern SDL_SCANCODE_CLEARAGAIN = (#const SDL_SCANCODE_CLEARAGAIN) :: Scancode
pattern SDL_SCANCODE_CRSEL = (#const SDL_SCANCODE_CRSEL) :: Scancode
pattern SDL_SCANCODE_EXSEL = (#const SDL_SCANCODE_EXSEL) :: Scancode
pattern SDL_SCANCODE_KP_00 = (#const SDL_SCANCODE_KP_00) :: Scancode
pattern SDL_SCANCODE_KP_000 = (#const SDL_SCANCODE_KP_000) :: Scancode
pattern SDL_SCANCODE_THOUSANDSSEPARATOR = (#const SDL_SCANCODE_THOUSANDSSEPARATOR) :: Scancode
pattern SDL_SCANCODE_DECIMALSEPARATOR = (#const SDL_SCANCODE_DECIMALSEPARATOR) :: Scancode
pattern SDL_SCANCODE_CURRENCYUNIT = (#const SDL_SCANCODE_CURRENCYUNIT) :: Scancode
pattern SDL_SCANCODE_CURRENCYSUBUNIT = (#const SDL_SCANCODE_CURRENCYSUBUNIT) :: Scancode
pattern SDL_SCANCODE_KP_LEFTPAREN = (#const SDL_SCANCODE_KP_LEFTPAREN) :: Scancode
pattern SDL_SCANCODE_KP_RIGHTPAREN = (#const SDL_SCANCODE_KP_RIGHTPAREN) :: Scancode
pattern SDL_SCANCODE_KP_LEFTBRACE = (#const SDL_SCANCODE_KP_LEFTBRACE) :: Scancode
pattern SDL_SCANCODE_KP_RIGHTBRACE = (#const SDL_SCANCODE_KP_RIGHTBRACE) :: Scancode
pattern SDL_SCANCODE_KP_TAB = (#const SDL_SCANCODE_KP_TAB) :: Scancode
pattern SDL_SCANCODE_KP_BACKSPACE = (#const SDL_SCANCODE_KP_BACKSPACE) :: Scancode
pattern SDL_SCANCODE_KP_A = (#const SDL_SCANCODE_KP_A) :: Scancode
pattern SDL_SCANCODE_KP_B = (#const SDL_SCANCODE_KP_B) :: Scancode
pattern SDL_SCANCODE_KP_C = (#const SDL_SCANCODE_KP_C) :: Scancode
pattern SDL_SCANCODE_KP_D = (#const SDL_SCANCODE_KP_D) :: Scancode
pattern SDL_SCANCODE_KP_E = (#const SDL_SCANCODE_KP_E) :: Scancode
pattern SDL_SCANCODE_KP_F = (#const SDL_SCANCODE_KP_F) :: Scancode
pattern SDL_SCANCODE_KP_XOR = (#const SDL_SCANCODE_KP_XOR) :: Scancode
pattern SDL_SCANCODE_KP_POWER = (#const SDL_SCANCODE_KP_POWER) :: Scancode
pattern SDL_SCANCODE_KP_PERCENT = (#const SDL_SCANCODE_KP_PERCENT) :: Scancode
pattern SDL_SCANCODE_KP_LESS = (#const SDL_SCANCODE_KP_LESS) :: Scancode
pattern SDL_SCANCODE_KP_GREATER = (#const SDL_SCANCODE_KP_GREATER) :: Scancode
pattern SDL_SCANCODE_KP_AMPERSAND = (#const SDL_SCANCODE_KP_AMPERSAND) :: Scancode
pattern SDL_SCANCODE_KP_DBLAMPERSAND = (#const SDL_SCANCODE_KP_DBLAMPERSAND) :: Scancode
pattern SDL_SCANCODE_KP_VERTICALBAR = (#const SDL_SCANCODE_KP_VERTICALBAR) :: Scancode
pattern SDL_SCANCODE_KP_DBLVERTICALBAR = (#const SDL_SCANCODE_KP_DBLVERTICALBAR) :: Scancode
pattern SDL_SCANCODE_KP_COLON = (#const SDL_SCANCODE_KP_COLON) :: Scancode
pattern SDL_SCANCODE_KP_HASH = (#const SDL_SCANCODE_KP_HASH) :: Scancode
pattern SDL_SCANCODE_KP_SPACE = (#const SDL_SCANCODE_KP_SPACE) :: Scancode
pattern SDL_SCANCODE_KP_AT = (#const SDL_SCANCODE_KP_AT) :: Scancode
pattern SDL_SCANCODE_KP_EXCLAM = (#const SDL_SCANCODE_KP_EXCLAM) :: Scancode
pattern SDL_SCANCODE_KP_MEMSTORE = (#const SDL_SCANCODE_KP_MEMSTORE) :: Scancode
pattern SDL_SCANCODE_KP_MEMRECALL = (#const SDL_SCANCODE_KP_MEMRECALL) :: Scancode
pattern SDL_SCANCODE_KP_MEMCLEAR = (#const SDL_SCANCODE_KP_MEMCLEAR) :: Scancode
pattern SDL_SCANCODE_KP_MEMADD = (#const SDL_SCANCODE_KP_MEMADD) :: Scancode
pattern SDL_SCANCODE_KP_MEMSUBTRACT = (#const SDL_SCANCODE_KP_MEMSUBTRACT) :: Scancode
pattern SDL_SCANCODE_KP_MEMMULTIPLY = (#const SDL_SCANCODE_KP_MEMMULTIPLY) :: Scancode
pattern SDL_SCANCODE_KP_MEMDIVIDE = (#const SDL_SCANCODE_KP_MEMDIVIDE) :: Scancode
pattern SDL_SCANCODE_KP_PLUSMINUS = (#const SDL_SCANCODE_KP_PLUSMINUS) :: Scancode
pattern SDL_SCANCODE_KP_CLEAR = (#const SDL_SCANCODE_KP_CLEAR) :: Scancode
pattern SDL_SCANCODE_KP_CLEARENTRY = (#const SDL_SCANCODE_KP_CLEARENTRY) :: Scancode
pattern SDL_SCANCODE_KP_BINARY = (#const SDL_SCANCODE_KP_BINARY) :: Scancode
pattern SDL_SCANCODE_KP_OCTAL = (#const SDL_SCANCODE_KP_OCTAL) :: Scancode
pattern SDL_SCANCODE_KP_DECIMAL = (#const SDL_SCANCODE_KP_DECIMAL) :: Scancode
pattern SDL_SCANCODE_KP_HEXADECIMAL = (#const SDL_SCANCODE_KP_HEXADECIMAL) :: Scancode
pattern SDL_SCANCODE_LCTRL = (#const SDL_SCANCODE_LCTRL) :: Scancode
pattern SDL_SCANCODE_LSHIFT = (#const SDL_SCANCODE_LSHIFT) :: Scancode
pattern SDL_SCANCODE_LALT = (#const SDL_SCANCODE_LALT) :: Scancode
pattern SDL_SCANCODE_LGUI = (#const SDL_SCANCODE_LGUI) :: Scancode
pattern SDL_SCANCODE_RCTRL = (#const SDL_SCANCODE_RCTRL) :: Scancode
pattern SDL_SCANCODE_RSHIFT = (#const SDL_SCANCODE_RSHIFT) :: Scancode
pattern SDL_SCANCODE_RALT = (#const SDL_SCANCODE_RALT) :: Scancode
pattern SDL_SCANCODE_RGUI = (#const SDL_SCANCODE_RGUI) :: Scancode
pattern SDL_SCANCODE_MODE = (#const SDL_SCANCODE_MODE) :: Scancode
pattern SDL_SCANCODE_MEDIA_NEXT_TRACK = (#const SDL_SCANCODE_MEDIA_NEXT_TRACK) :: Scancode
pattern SDL_SCANCODE_MEDIA_PREVIOUS_TRACK = (#const SDL_SCANCODE_MEDIA_PREVIOUS_TRACK) :: Scancode
pattern SDL_SCANCODE_MEDIA_STOP = (#const SDL_SCANCODE_MEDIA_STOP) :: Scancode
pattern SDL_SCANCODE_MEDIA_PLAY = (#const SDL_SCANCODE_MEDIA_PLAY) :: Scancode
pattern SDL_SCANCODE_MEDIA_SELECT = (#const SDL_SCANCODE_MEDIA_SELECT) :: Scancode
pattern SDL_SCANCODE_AC_SEARCH = (#const SDL_SCANCODE_AC_SEARCH) :: Scancode
pattern SDL_SCANCODE_AC_HOME = (#const SDL_SCANCODE_AC_HOME) :: Scancode
pattern SDL_SCANCODE_AC_BACK = (#const SDL_SCANCODE_AC_BACK) :: Scancode
pattern SDL_SCANCODE_AC_FORWARD = (#const SDL_SCANCODE_AC_FORWARD) :: Scancode
pattern SDL_SCANCODE_AC_STOP = (#const SDL_SCANCODE_AC_STOP) :: Scancode
pattern SDL_SCANCODE_AC_REFRESH = (#const SDL_SCANCODE_AC_REFRESH) :: Scancode
pattern SDL_SCANCODE_AC_BOOKMARKS = (#const SDL_SCANCODE_AC_BOOKMARKS) :: Scancode
pattern SDL_SCANCODE_MEDIA_EJECT = (#const SDL_SCANCODE_MEDIA_EJECT) :: Scancode
pattern SDL_SCANCODE_SLEEP = (#const SDL_SCANCODE_SLEEP) :: Scancode
pattern SDL_SCANCODE_COUNT = (#const SDL_SCANCODE_COUNT) :: Scancode

pattern SDL_SENSOR_INVALID = (#const SDL_SENSOR_INVALID) :: SensorType
pattern SDL_SENSOR_UNKNOWN = (#const SDL_SENSOR_UNKNOWN) :: SensorType
pattern SDL_SENSOR_ACCEL = (#const SDL_SENSOR_ACCEL) :: SensorType
pattern SDL_SENSOR_GYRO = (#const SDL_SENSOR_GYRO) :: SensorType
pattern SDL_SENSOR_ACCEL_L = (#const SDL_SENSOR_ACCEL_L) :: SensorType
pattern SDL_SENSOR_GYRO_L = (#const SDL_SENSOR_GYRO_L) :: SensorType
pattern SDL_SENSOR_ACCEL_R = (#const SDL_SENSOR_ACCEL_R) :: SensorType
pattern SDL_SENSOR_GYRO_R = (#const SDL_SENSOR_GYRO_R) :: SensorType

pattern SDL_SYSTEM_CURSOR_DEFAULT = (#const SDL_SYSTEM_CURSOR_DEFAULT) :: SystemCursor
pattern SDL_SYSTEM_CURSOR_TEXT = (#const SDL_SYSTEM_CURSOR_TEXT) :: SystemCursor
pattern SDL_SYSTEM_CURSOR_WAIT = (#const SDL_SYSTEM_CURSOR_WAIT) :: SystemCursor
pattern SDL_SYSTEM_CURSOR_CROSSHAIR = (#const SDL_SYSTEM_CURSOR_CROSSHAIR) :: SystemCursor
pattern SDL_SYSTEM_CURSOR_PROGRESS = (#const SDL_SYSTEM_CURSOR_PROGRESS) :: SystemCursor
pattern SDL_SYSTEM_CURSOR_NWSE_RESIZE = (#const SDL_SYSTEM_CURSOR_NWSE_RESIZE) :: SystemCursor
pattern SDL_SYSTEM_CURSOR_NESW_RESIZE = (#const SDL_SYSTEM_CURSOR_NESW_RESIZE) :: SystemCursor
pattern SDL_SYSTEM_CURSOR_EW_RESIZE = (#const SDL_SYSTEM_CURSOR_EW_RESIZE) :: SystemCursor
pattern SDL_SYSTEM_CURSOR_NS_RESIZE = (#const SDL_SYSTEM_CURSOR_NS_RESIZE) :: SystemCursor
pattern SDL_SYSTEM_CURSOR_MOVE = (#const SDL_SYSTEM_CURSOR_MOVE) :: SystemCursor
pattern SDL_SYSTEM_CURSOR_NOT_ALLOWED = (#const SDL_SYSTEM_CURSOR_NOT_ALLOWED) :: SystemCursor
pattern SDL_SYSTEM_CURSOR_POINTER = (#const SDL_SYSTEM_CURSOR_POINTER) :: SystemCursor
pattern SDL_SYSTEM_CURSOR_COUNT = (#const SDL_SYSTEM_CURSOR_COUNT) :: SystemCursor

pattern SDL_THREAD_PRIORITY_LOW = (#const SDL_THREAD_PRIORITY_LOW) :: ThreadPriority
pattern SDL_THREAD_PRIORITY_NORMAL = (#const SDL_THREAD_PRIORITY_NORMAL) :: ThreadPriority
pattern SDL_THREAD_PRIORITY_HIGH = (#const SDL_THREAD_PRIORITY_HIGH) :: ThreadPriority

pattern SDL_BUTTON_LEFT = (#const SDL_BUTTON_LEFT)
pattern SDL_BUTTON_MIDDLE = (#const SDL_BUTTON_MIDDLE)
pattern SDL_BUTTON_RIGHT = (#const SDL_BUTTON_RIGHT)
pattern SDL_BUTTON_X1 = (#const SDL_BUTTON_X1)
pattern SDL_BUTTON_X2 = (#const SDL_BUTTON_X2)
pattern SDL_BUTTON_LMASK = (#const SDL_BUTTON_LMASK)
pattern SDL_BUTTON_MMASK = (#const SDL_BUTTON_MMASK)
pattern SDL_BUTTON_RMASK = (#const SDL_BUTTON_RMASK)
pattern SDL_BUTTON_X1MASK = (#const SDL_BUTTON_X1MASK)
pattern SDL_BUTTON_X2MASK = (#const SDL_BUTTON_X2MASK)

pattern SDL_MOUSEWHEEL_NORMAL = (#const SDL_MOUSEWHEEL_NORMAL)
pattern SDL_MOUSEWHEEL_FLIPPED = (#const SDL_MOUSEWHEEL_FLIPPED)

pattern SDL_EVENT_FIRST = (#const SDL_EVENT_FIRST)
pattern SDL_EVENT_QUIT = (#const SDL_EVENT_QUIT)
pattern SDL_EVENT_TERMINATING = (#const SDL_EVENT_TERMINATING)
pattern SDL_EVENT_LOW_MEMORY = (#const SDL_EVENT_LOW_MEMORY)
pattern SDL_EVENT_WILL_ENTER_BACKGROUND = (#const SDL_EVENT_WILL_ENTER_BACKGROUND)
pattern SDL_EVENT_DID_ENTER_BACKGROUND = (#const SDL_EVENT_DID_ENTER_BACKGROUND)
pattern SDL_EVENT_WILL_ENTER_FOREGROUND = (#const SDL_EVENT_WILL_ENTER_FOREGROUND)
pattern SDL_EVENT_DID_ENTER_FOREGROUND = (#const SDL_EVENT_DID_ENTER_FOREGROUND)
pattern SDL_EVENT_KEY_DOWN = (#const SDL_EVENT_KEY_DOWN)
pattern SDL_EVENT_KEY_UP = (#const SDL_EVENT_KEY_UP)
pattern SDL_EVENT_TEXT_EDITING = (#const SDL_EVENT_TEXT_EDITING)
pattern SDL_EVENT_TEXT_INPUT = (#const SDL_EVENT_TEXT_INPUT)
pattern SDL_EVENT_KEYMAP_CHANGED = (#const SDL_EVENT_KEYMAP_CHANGED)
pattern SDL_EVENT_MOUSE_MOTION = (#const SDL_EVENT_MOUSE_MOTION)
pattern SDL_EVENT_MOUSE_BUTTON_DOWN = (#const SDL_EVENT_MOUSE_BUTTON_DOWN)
pattern SDL_EVENT_MOUSE_BUTTON_UP = (#const SDL_EVENT_MOUSE_BUTTON_UP)
pattern SDL_EVENT_MOUSE_WHEEL = (#const SDL_EVENT_MOUSE_WHEEL)
pattern SDL_EVENT_JOYSTICK_AXIS_MOTION = (#const SDL_EVENT_JOYSTICK_AXIS_MOTION)
pattern SDL_EVENT_JOYSTICK_BALL_MOTION = (#const SDL_EVENT_JOYSTICK_BALL_MOTION)
pattern SDL_EVENT_JOYSTICK_HAT_MOTION = (#const SDL_EVENT_JOYSTICK_HAT_MOTION)
pattern SDL_EVENT_JOYSTICK_BUTTON_DOWN = (#const SDL_EVENT_JOYSTICK_BUTTON_DOWN)
pattern SDL_EVENT_JOYSTICK_BUTTON_UP = (#const SDL_EVENT_JOYSTICK_BUTTON_UP)
pattern SDL_EVENT_JOYSTICK_ADDED = (#const SDL_EVENT_JOYSTICK_ADDED)
pattern SDL_EVENT_JOYSTICK_REMOVED = (#const SDL_EVENT_JOYSTICK_REMOVED)
pattern SDL_EVENT_GAMEPAD_AXIS_MOTION = (#const SDL_EVENT_GAMEPAD_AXIS_MOTION)
pattern SDL_EVENT_GAMEPAD_BUTTON_DOWN = (#const SDL_EVENT_GAMEPAD_BUTTON_DOWN)
pattern SDL_EVENT_GAMEPAD_BUTTON_UP = (#const SDL_EVENT_GAMEPAD_BUTTON_UP)
pattern SDL_EVENT_GAMEPAD_ADDED = (#const SDL_EVENT_GAMEPAD_ADDED)
pattern SDL_EVENT_GAMEPAD_REMOVED = (#const SDL_EVENT_GAMEPAD_REMOVED)
pattern SDL_EVENT_GAMEPAD_REMAPPED = (#const SDL_EVENT_GAMEPAD_REMAPPED)
pattern SDL_EVENT_FINGER_DOWN = (#const SDL_EVENT_FINGER_DOWN)
pattern SDL_EVENT_FINGER_UP = (#const SDL_EVENT_FINGER_UP)
pattern SDL_EVENT_FINGER_MOTION = (#const SDL_EVENT_FINGER_MOTION)
pattern SDL_EVENT_CLIPBOARD_UPDATE = (#const SDL_EVENT_CLIPBOARD_UPDATE)
pattern SDL_EVENT_DROP_FILE = (#const SDL_EVENT_DROP_FILE)
pattern SDL_EVENT_AUDIO_DEVICE_ADDED = (#const SDL_EVENT_AUDIO_DEVICE_ADDED)
pattern SDL_EVENT_AUDIO_DEVICE_REMOVED = (#const SDL_EVENT_AUDIO_DEVICE_REMOVED)
pattern SDL_EVENT_RENDER_TARGETS_RESET = (#const SDL_EVENT_RENDER_TARGETS_RESET)
pattern SDL_EVENT_RENDER_DEVICE_RESET = (#const SDL_EVENT_RENDER_DEVICE_RESET)
pattern SDL_EVENT_USER = (#const SDL_EVENT_USER)
pattern SDL_EVENT_LAST = (#const SDL_EVENT_LAST)

pattern SDL_HAT_CENTERED = (#const SDL_HAT_CENTERED)
pattern SDL_HAT_UP = (#const SDL_HAT_UP)
pattern SDL_HAT_RIGHT = (#const SDL_HAT_RIGHT)
pattern SDL_HAT_DOWN = (#const SDL_HAT_DOWN)
pattern SDL_HAT_LEFT = (#const SDL_HAT_LEFT)
pattern SDL_HAT_RIGHTUP = (#const SDL_HAT_RIGHTUP)
pattern SDL_HAT_RIGHTDOWN = (#const SDL_HAT_RIGHTDOWN)
pattern SDL_HAT_LEFTUP = (#const SDL_HAT_LEFTUP)
pattern SDL_HAT_LEFTDOWN = (#const SDL_HAT_LEFTDOWN)

pattern SDL_LOG_CATEGORY_APPLICATION = (#const SDL_LOG_CATEGORY_APPLICATION)
pattern SDL_LOG_CATEGORY_ERROR = (#const SDL_LOG_CATEGORY_ERROR)
pattern SDL_LOG_CATEGORY_ASSERT = (#const SDL_LOG_CATEGORY_ASSERT)
pattern SDL_LOG_CATEGORY_SYSTEM = (#const SDL_LOG_CATEGORY_SYSTEM)
pattern SDL_LOG_CATEGORY_AUDIO = (#const SDL_LOG_CATEGORY_AUDIO)
pattern SDL_LOG_CATEGORY_VIDEO = (#const SDL_LOG_CATEGORY_VIDEO)
pattern SDL_LOG_CATEGORY_RENDER = (#const SDL_LOG_CATEGORY_RENDER)
pattern SDL_LOG_CATEGORY_INPUT = (#const SDL_LOG_CATEGORY_INPUT)
pattern SDL_LOG_CATEGORY_TEST = (#const SDL_LOG_CATEGORY_TEST)
pattern SDL_LOG_CATEGORY_CUSTOM = (#const SDL_LOG_CATEGORY_CUSTOM)

pattern SDL_MESSAGEBOX_ERROR = (#const SDL_MESSAGEBOX_ERROR)
pattern SDL_MESSAGEBOX_WARNING = (#const SDL_MESSAGEBOX_WARNING)
pattern SDL_MESSAGEBOX_INFORMATION = (#const SDL_MESSAGEBOX_INFORMATION)

pattern SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT = (#const SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT)
pattern SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT = (#const SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT)

pattern SDL_GL_CONTEXT_PROFILE_CORE = (#const SDL_GL_CONTEXT_PROFILE_CORE)
pattern SDL_GL_CONTEXT_PROFILE_COMPATIBILITY = (#const SDL_GL_CONTEXT_PROFILE_COMPATIBILITY)
pattern SDL_GL_CONTEXT_PROFILE_ES = (#const SDL_GL_CONTEXT_PROFILE_ES)

pattern SDL_GL_CONTEXT_DEBUG_FLAG = (#const SDL_GL_CONTEXT_DEBUG_FLAG)
pattern SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG = (#const SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
pattern SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG = (#const SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG)
pattern SDL_GL_CONTEXT_RESET_ISOLATION_FLAG = (#const SDL_GL_CONTEXT_RESET_ISOLATION_FLAG)

pattern SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE = (#const SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE)
pattern SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH = (#const SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH)

pattern SDL_PIXELFORMAT_UNKNOWN = (#const SDL_PIXELFORMAT_UNKNOWN)
pattern SDL_PIXELFORMAT_INDEX1LSB = (#const SDL_PIXELFORMAT_INDEX1LSB)
pattern SDL_PIXELFORMAT_INDEX1MSB = (#const SDL_PIXELFORMAT_INDEX1MSB)
pattern SDL_PIXELFORMAT_INDEX4LSB = (#const SDL_PIXELFORMAT_INDEX4LSB)
pattern SDL_PIXELFORMAT_INDEX4MSB = (#const SDL_PIXELFORMAT_INDEX4MSB)
pattern SDL_PIXELFORMAT_INDEX8 = (#const SDL_PIXELFORMAT_INDEX8)
pattern SDL_PIXELFORMAT_RGB332 = (#const SDL_PIXELFORMAT_RGB332)
pattern SDL_PIXELFORMAT_XRGB4444 = (#const SDL_PIXELFORMAT_XRGB4444)
pattern SDL_PIXELFORMAT_XRGB1555 = (#const SDL_PIXELFORMAT_XRGB1555)
pattern SDL_PIXELFORMAT_XBGR1555 = (#const SDL_PIXELFORMAT_XBGR1555)
pattern SDL_PIXELFORMAT_ARGB4444 = (#const SDL_PIXELFORMAT_ARGB4444)
pattern SDL_PIXELFORMAT_RGBA4444 = (#const SDL_PIXELFORMAT_RGBA4444)
pattern SDL_PIXELFORMAT_ABGR4444 = (#const SDL_PIXELFORMAT_ABGR4444)
pattern SDL_PIXELFORMAT_BGRA4444 = (#const SDL_PIXELFORMAT_BGRA4444)
pattern SDL_PIXELFORMAT_ARGB1555 = (#const SDL_PIXELFORMAT_ARGB1555)
pattern SDL_PIXELFORMAT_RGBA5551 = (#const SDL_PIXELFORMAT_RGBA5551)
pattern SDL_PIXELFORMAT_ABGR1555 = (#const SDL_PIXELFORMAT_ABGR1555)
pattern SDL_PIXELFORMAT_BGRA5551 = (#const SDL_PIXELFORMAT_BGRA5551)
pattern SDL_PIXELFORMAT_RGB565 = (#const SDL_PIXELFORMAT_RGB565)
pattern SDL_PIXELFORMAT_BGR565 = (#const SDL_PIXELFORMAT_BGR565)
pattern SDL_PIXELFORMAT_RGB24 = (#const SDL_PIXELFORMAT_RGB24)
pattern SDL_PIXELFORMAT_BGR24 = (#const SDL_PIXELFORMAT_BGR24)
pattern SDL_PIXELFORMAT_XRGB8888 = (#const SDL_PIXELFORMAT_XRGB8888)
pattern SDL_PIXELFORMAT_RGBX8888 = (#const SDL_PIXELFORMAT_RGBX8888)
pattern SDL_PIXELFORMAT_XBGR8888 = (#const SDL_PIXELFORMAT_XBGR8888)
pattern SDL_PIXELFORMAT_BGRX8888 = (#const SDL_PIXELFORMAT_BGRX8888)
pattern SDL_PIXELFORMAT_ARGB8888 = (#const SDL_PIXELFORMAT_ARGB8888)
pattern SDL_PIXELFORMAT_RGBA8888 = (#const SDL_PIXELFORMAT_RGBA8888)
pattern SDL_PIXELFORMAT_ABGR8888 = (#const SDL_PIXELFORMAT_ABGR8888)
pattern SDL_PIXELFORMAT_BGRA8888 = (#const SDL_PIXELFORMAT_BGRA8888)
pattern SDL_PIXELFORMAT_ARGB2101010 = (#const SDL_PIXELFORMAT_ARGB2101010)
pattern SDL_PIXELFORMAT_YV12 = (#const SDL_PIXELFORMAT_YV12)
pattern SDL_PIXELFORMAT_IYUV = (#const SDL_PIXELFORMAT_IYUV)
pattern SDL_PIXELFORMAT_YUY2 = (#const SDL_PIXELFORMAT_YUY2)
pattern SDL_PIXELFORMAT_UYVY = (#const SDL_PIXELFORMAT_UYVY)
pattern SDL_PIXELFORMAT_YVYU = (#const SDL_PIXELFORMAT_YVYU)

pattern SDL_TEXTUREACCESS_STATIC    = (#const SDL_TEXTUREACCESS_STATIC) :: TextureAccess
pattern SDL_TEXTUREACCESS_STREAMING = (#const SDL_TEXTUREACCESS_STREAMING) :: TextureAccess
pattern SDL_TEXTUREACCESS_TARGET    = (#const SDL_TEXTUREACCESS_TARGET) :: TextureAccess

pattern SDL_TOUCH_MOUSEID = (#const SDL_TOUCH_MOUSEID)

pattern SDL_EVENT_WINDOW_SHOWN = (#const SDL_EVENT_WINDOW_SHOWN)
pattern SDL_EVENT_WINDOW_HIDDEN = (#const SDL_EVENT_WINDOW_HIDDEN)
pattern SDL_EVENT_WINDOW_EXPOSED = (#const SDL_EVENT_WINDOW_EXPOSED)
pattern SDL_EVENT_WINDOW_MOVED = (#const SDL_EVENT_WINDOW_MOVED)
pattern SDL_EVENT_WINDOW_RESIZED = (#const SDL_EVENT_WINDOW_RESIZED)
pattern SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED = (#const SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED)
pattern SDL_EVENT_WINDOW_MINIMIZED = (#const SDL_EVENT_WINDOW_MINIMIZED)
pattern SDL_EVENT_WINDOW_MAXIMIZED = (#const SDL_EVENT_WINDOW_MAXIMIZED)
pattern SDL_EVENT_WINDOW_RESTORED = (#const SDL_EVENT_WINDOW_RESTORED)
pattern SDL_EVENT_WINDOW_MOUSE_ENTER = (#const SDL_EVENT_WINDOW_MOUSE_ENTER)
pattern SDL_EVENT_WINDOW_MOUSE_LEAVE = (#const SDL_EVENT_WINDOW_MOUSE_LEAVE)
pattern SDL_EVENT_WINDOW_FOCUS_GAINED = (#const SDL_EVENT_WINDOW_FOCUS_GAINED)
pattern SDL_EVENT_WINDOW_FOCUS_LOST = (#const SDL_EVENT_WINDOW_FOCUS_LOST)
pattern SDL_EVENT_WINDOW_CLOSE_REQUESTED = (#const SDL_EVENT_WINDOW_CLOSE_REQUESTED)

pattern SDL_WINDOW_FULLSCREEN = (#const SDL_WINDOW_FULLSCREEN)
pattern SDL_WINDOW_OPENGL = (#const SDL_WINDOW_OPENGL)
pattern SDL_WINDOW_HIDDEN = (#const SDL_WINDOW_HIDDEN)
pattern SDL_WINDOW_BORDERLESS = (#const SDL_WINDOW_BORDERLESS)
pattern SDL_WINDOW_RESIZABLE = (#const SDL_WINDOW_RESIZABLE)
pattern SDL_WINDOW_MINIMIZED = (#const SDL_WINDOW_MINIMIZED)
pattern SDL_WINDOW_MAXIMIZED = (#const SDL_WINDOW_MAXIMIZED)
pattern SDL_WINDOW_MOUSE_GRABBED = (#const SDL_WINDOW_MOUSE_GRABBED)
pattern SDL_WINDOW_INPUT_FOCUS = (#const SDL_WINDOW_INPUT_FOCUS)
pattern SDL_WINDOW_MOUSE_FOCUS = (#const SDL_WINDOW_MOUSE_FOCUS)
pattern SDL_WINDOW_HIGH_PIXEL_DENSITY = (#const SDL_WINDOW_HIGH_PIXEL_DENSITY)
pattern SDL_WINDOW_MOUSE_CAPTURE = (#const SDL_WINDOW_MOUSE_CAPTURE)
pattern SDL_WINDOW_VULKAN = (#const SDL_WINDOW_VULKAN)

pattern SDL_WINDOWPOS_UNDEFINED = (#const SDL_WINDOWPOS_UNDEFINED)
pattern SDL_WINDOWPOS_CENTERED = (#const SDL_WINDOWPOS_CENTERED)
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_0 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(0))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_1 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(1))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_2 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(2))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_3 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(3))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_4 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(4))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_5 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(5))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_6 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(6))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_7 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(7))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_8 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(8))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_9 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(9))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_10 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(10))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_11 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(11))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_12 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(12))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_13 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(13))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_14 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(14))
pattern SDL_WINDOWPOS_CENTERED_DISPLAY_15 = (#const SDL_WINDOWPOS_CENTERED_DISPLAY(15))

pattern SDL_HAPTIC_CONSTANT = (#const SDL_HAPTIC_CONSTANT)

-- * Storables
instance Storable GamepadAxis where
  sizeOf _ = sizeOf (undefined :: Int32)
  alignment _ = alignment (undefined :: Int32)
  peek ptr = GamepadAxis <$> peek (castPtr ptr :: Ptr Int32)
  poke ptr (GamepadAxis a) = poke (castPtr ptr :: Ptr Int32) a

instance Storable GamepadButton where
  sizeOf _ = sizeOf (undefined :: CInt)
  alignment _ = alignment (undefined :: CInt)
  peek ptr = GamepadButton <$> peek (castPtr ptr :: Ptr Int32)
  poke ptr (GamepadButton b) = poke (castPtr ptr :: Ptr Int32) b
