{ jitsi-meet }:

jitsi-meet.overrideAttrs (prev: {
  patches = [ ./plausible.patch ];
})
