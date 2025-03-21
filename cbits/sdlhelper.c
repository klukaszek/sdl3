#include <string.h>
#include <stdlib.h>
#include "../include/sdlhelper.h"

int SDLHelper_GetEventBufferSize() { return 64; }
SDL_Event *SDLHelper_GetEventBuffer() {
  static SDL_Event *buffer = NULL;
  if(buffer == NULL) {
    /* leak an inconsequental amount of memory */
    buffer = calloc(SDLHelper_GetEventBufferSize(), sizeof(SDL_Event));
  }
  return buffer;
}

void SDLHelper_JoystickGetDeviceGUID (int device_index, SDL_GUID *guid)
{
  SDL_GUID t = SDL_GetJoystickGUIDForID (device_index);
  memcpy (guid, &t, sizeof (*guid));
}

void SDLHelper_JoystickGetGUID (SDL_Joystick *joystick, SDL_GUID *guid)
{
  SDL_GUID t = SDL_GetJoystickGUID (joystick);
  memcpy (guid, &t, sizeof (*guid));
}

void SDLHelper_JoystickGetGUIDFromString (const char *pchGUID, SDL_GUID *guid)
{
  SDL_GUID t = SDL_StringToGUID (pchGUID);
  memcpy (guid, &t, sizeof (*guid));
}

void SDLHelper_JoystickGetGUIDString (const SDL_GUID *guid, char *gszGUID, int cbGUID)
{
  SDL_GUIDToString (*guid, gszGUID, cbGUID);
}

// Gamepad bindings are now a union of both buttons and axes. I've gotta update this.

void SDLHelper_GameControllerGetBindForAxis (SDL_Gamepad *gamecontroller, SDL_GamepadAxis axis, SDL_GamepadBinding *bind)
{
  // SDL_GamepadBinding t = SDL_GetGamepadBindings (gamecontroller, axis);
  // memcpy (bind, &t, sizeof (*bind));
}

void SDLHelper_GameControllerGetBindForButton (SDL_Gamepad *gamecontroller, SDL_GamepadButton button, SDL_GamepadBinding *bind)
{
  // SDL_GamepadBinding t = SDL_GetGamepadBindings (gamecontroller, button);
  // memcpy (bind, &t, sizeof (*bind));
}

char *SDLHelper_GameControllerMappingForGUID (const SDL_GUID *guid)
{
  return SDL_GetGamepadMappingForGUID (*guid);
}

void SDLHelper_LogMessage (int category, SDL_LogPriority priority, const char *str)
{
  SDL_LogMessage (category, priority, "%s", str);
}

int SDLHelper_SetError (const char *str)
{
  return SDL_SetError ("%s", str);
}

int SDLHelper_RenderFillRectEx(SDL_Renderer*   renderer, int x, int y, int w, int h)
{
  SDL_FRect rect;
  rect.x=x;
  rect.y=y;
  rect.w=w;
  rect.h=h;
  return SDL_RenderFillRect(renderer,&rect);
}
