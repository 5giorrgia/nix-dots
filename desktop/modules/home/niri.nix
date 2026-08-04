{ config, pkgs, ... }:

{
  home.file.".config/niri/config.kdl".text = ''
      include optional=true "~/.config/niri/noctalia.kdl"

      input {

          keyboard {
              xkb {
                  layout "it"
		  variant "us"
              }
          }

          mouse {
              accel-speed -0.3
              accel-profile "flat"
          }

          warp-mouse-to-focus

          focus-follows-mouse max-scroll-amount="100%"
      }

      cursor {
          xcursor-theme "Bibata-Modern-Classic"
          xcursor-size 16

          hide-when-typing
          hide-after-inactive-ms 1000
      }

      output "DP-1" {
          mode "1920x1080@200"
          scale 1
          transform "normal"
          position x=0 y=0
      }

      output "HDMI-A-1" {
          mode "1920x1080@74.973"
          scale 1
          transform "normal"
          position x=1920 y=0
      }

      layout {
          gaps 10
          center-focused-column "never"
          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }

          default-column-width { proportion 0.5; }

          focus-ring {
              width 2
          }

          border {
              off
          }

          shadow {
              on
              draw-behind-window true
              softness 30
              spread 5
              offset x=0 y=5
          }
      }

      spawn-at-startup "/home/denis/.config/niri/scripts/noctalia-overview-widgets.sh"

      hotkey-overlay {
          skip-at-startup
      }

      prefer-no-csd

      animations {
          // slowdown 3.0 // 1 is the default
      }

      window-rule {
          match app-id=r#"waterfox$"# title="^Picture-in-Picture$"
          open-floating true
      }

      /-window-rule {
          match app-id=r#"^org\.keepassxc\.KeePassXC$"#
          match app-id=r#"^org\.gnome\.World\.Secrets$"#

          block-out-from "screen-capture"

          // Use this instead if you want them visible on third-party screenshot tools.
          // block-out-from "screencast"
      }

      window-rule {
          match app-id="steam" title=r#"^notificationtoasts_\d+_desktop$"#

          open-floating true
          open-focused false
          default-floating-position x=16 y=16 relative-to="top-right"

          border {
              off
          }
      }

      window-rule {
          geometry-corner-radius 15
          clip-to-geometry true
      }

      gestures {
          hot-corners {
              off
          }
      }

      binds {
          Mod+Minus { show-hotkey-overlay; }

          Mod+T hotkey-overlay-title="Open the terminal" { spawn "kitty";                                 }
          Mod+E hotkey-overlay-title="Open the file manager" { spawn "nautilus";                                 }
          Mod+U hotkey-overlay-title="Run rofi"          { spawn "rofi" "-show" "drun";                   }
          Mod+R hotkey-overlay-title="Run the launcher"  { spawn-sh "noctalia msg panel-toggle launcher"; }

          XF86AudioRaiseVolume  allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
          XF86AudioLowerVolume  allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";        }
          XF86AudioMute         allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";        }
          XF86AudioMicMute      allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";      }

          XF86AudioPlay         allow-when-locked=true { spawn-sh "playerctl play-pause"; }
          XF86AudioStop         allow-when-locked=true { spawn-sh "playerctl stop";       }
          XF86AudioPrev         allow-when-locked=true { spawn-sh "playerctl previous";   }
          XF86AudioNext         allow-when-locked=true { spawn-sh "playerctl next";       }

          XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

          Mod+Space hotkey-overlay-title="Open the overview"              { toggle-overview; }
          Mod+C     hotkey-overlay-title="Close a window" repeat=false    { close-window;    }

          Mod+Shift+Escape { spawn-sh "pkill noctalia; sleep 1; noctalia"; }
          Mod+Shift+C { spawn-sh "noctalia msg panel-toggle yuuto/calculator:panel"; }
	  Mod+W { spawn-sh "noctalia msg panel-open wallpaper"; }
          Mod+Shift+W { spawn-sh "noctalia msg panel-toggle noctalia/wallhaven:browser"; }
          Mod+Ctrl+W  { spawn-sh "noctalia msg panel-toggle noctalia/mpvpaper:picker"; }
          Mod+Shift+S { spawn-sh "noctalia msg screenshot-region";        }
          Print { spawn-sh "noctalia msg screenshot-fullscreen pick";        }
          Alt+Print { spawn-sh "noctalia msg plugin noctalia/screen_recorder:service all toggle"; }
          Mod+P { spawn-sh "noctalia msg panel-open session"; }


          Mod+Left  { focus-column-left;  }
          Mod+Down  { focus-window-down;  }
          Mod+Up    { focus-window-up;    }
          Mod+Right { focus-column-right; }

          Mod+Ctrl+Left  { move-column-left;  }
          Mod+Ctrl+Down  { move-window-down;  }
          Mod+Ctrl+Up    { move-window-up;    }
          Mod+Ctrl+Right { move-column-right; }

          Alt+Left  { focus-monitor-left;  }
          Alt+Down  { focus-monitor-down;  }
          Alt+Up    { focus-monitor-up;    }
          Alt+Right { focus-monitor-right; }

          Alt+Ctrl+Left  { move-column-to-monitor-left;  }
          Alt+Ctrl+Down  { move-column-to-monitor-down;  }
          Alt+Ctrl+Up    { move-column-to-monitor-up;    }
          Alt+Ctrl+Right { move-column-to-monitor-right; }

          Alt+Shift+Ctrl+Left  { move-window-to-monitor-left;  }
          Alt+Shift+Ctrl+Down  { move-window-to-monitor-down;  }
          Alt+Shift+Ctrl+Up    { move-window-to-monitor-up;    }
          Alt+Shift+Ctrl+Right { move-window-to-monitor-right; }

          Alt+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
          Alt+WheelScrollUp        cooldown-ms=150 { focus-workspace-up;   }

          Alt+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
          Alt+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up;   }

          Mod+WheelScrollDown       { focus-column-right; }
          Mod+WheelScrollUp         { focus-column-left;  }

          Mod+Ctrl+WheelScrollDown  { move-column-right;  }
          Mod+Ctrl+WheelScrollUp    { move-column-left;   }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }

          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }

          Mod+Shift+1 { move-window-to-workspace 1; }
          Mod+Shift+2 { move-window-to-workspace 2; }
          Mod+Shift+3 { move-window-to-workspace 3; }
          Mod+Shift+4 { move-window-to-workspace 4; }
          Mod+Shift+5 { move-window-to-workspace 5; }
          Mod+Shift+6 { move-window-to-workspace 6; }
          Mod+Shift+7 { move-window-to-workspace 7; }
          Mod+Shift+8 { move-window-to-workspace 8; }
          Mod+Shift+9 { move-window-to-workspace 9; }

          Mod+I { consume-or-expel-window-left;  }
          Mod+O { consume-or-expel-window-right; }

          Mod+D       { switch-preset-column-width;      }
          Mod+Shift+D { switch-preset-column-width-back; }

          Mod+Shift+R { switch-preset-window-height; }
          Mod+Ctrl+R  { reset-window-height;         }

          Mod+F { maximize-column;   }
          Mod+G { fullscreen-window; }

          Mod+Return      { center-column;          }
          Mod+Ctrl+Return { center-visible-columns; }

          Mod+H { set-column-width "-10%"; }
          Mod+L { set-column-width "+10%"; }

          Mod+J { set-window-height "-10%"; }
          Mod+K { set-window-height "+10%"; }

          Mod+S       { toggle-window-floating;                   }
          Mod+Ctrl+S  { switch-focus-between-floating-and-tiling; }

          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

          Mod+Shift+Q     { quit; }
          Ctrl+Alt+Delete { quit; }

          Mod+Shift+P { power-off-monitors; }
      }
    '';
}
