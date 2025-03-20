#ifndef _HS_SDL3_HELPER_H_
#define _HS_SDL3_HELPER_H_

#include <stddef.h>
#include <SDL3/SDL.h>

int SDLHelper_GetEventBufferSize(void);
SDL_Event *SDLHelper_GetEventBuffer(void);
void SDLHelper_JoystickGetDeviceGUID (int device_index, SDL_GUID *guid);
void SDLHelper_JoystickGetGUID (SDL_Joystick *joystick, SDL_GUID *guid);
void SDLHelper_JoystickGetGUIDFromString (const char *pchGUID, SDL_GUID *guid);
void SDLHelper_JoystickGetGUIDString (const SDL_GUID *guid, char *gszGUID, int cbGUID);

void SDLHelper_GameControllerGetBindForAxis (SDL_Gamepad *gamecontroller, SDL_GamepadAxis axis, SDL_GamepadBinding *bind);
void SDLHelper_GameControllerGetBindForButton (SDL_Gamepad *gamecontroller, SDL_GamepadButton button, SDL_GamepadBinding *bind);
char *SDLHelper_GameControllerMappingForGUID (const SDL_GUID *guid);

void SDLHelper_LogMessage (int category, SDL_LogPriority priority, const char *str);

int SDLHelper_RWclose (SDL_IOStream *ctx);
size_t SDLHelper_RWread (SDL_IOStream *ctx, void *ptr, size_t size, size_t maxnum);
Sint64 SDLHelper_RWseek (SDL_IOStream *ctx, Sint64 offset, int whence);
Sint64 SDLHelper_RWtell (SDL_IOStream *ctx);
size_t SDLHelper_RWwrite (SDL_IOStream *ctx, const void *ptr, size_t size, size_t num);

int SDLHelper_SetError(const char *str);

#endif
