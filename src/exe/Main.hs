{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (unless)
import Graphics.GL.Core33
import Graphics.GL.Types
import SDL

main :: IO ()
main = do
  initializeAll
  window <- createWindow "Witidecraft: Hi!" (defaultWindow { windowOpenGL = Just (defaultOpenGL { glProfile = Core Normal 3 3 }) })
  ctx <- glCreateContext window
  appLoop window ctx

appLoop :: Window -> GLContext -> IO ()
appLoop win ctx = do
  events <- pollEvents
  let eventIsQPress event =
        case eventPayload event of
          KeyboardEvent keyboardEvent ->
            keyboardEventKeyMotion keyboardEvent == Pressed &&
            keysymKeycode (keyboardEventKeysym keyboardEvent) == KeycodeEscape
          _ -> False
      qPressed = any eventIsQPress events
  glClearColor 0.2 0.3 0.3 1.0
  glClear GL_COLOR_BUFFER_BIT
  unless qPressed (appLoop win ctx)
