# TTS app

Simple gtk4 frontend for a [TTS server](https://github.com/coqui-ai/TTS).


## Build && install

You will need gtk4 and gstreamer installed.

```console
mkdir build
cd build
meson ..
ninja
```

or with nix

``` console
nix-build
```

First start the tts server. i.e.,

```
$ tts-server --model_name tts_models/en/ljspeech/tacotron2-DDC --vocoder_name vocoder_models/en/ljspeech/hifigan_v2
```

Than the app

```console
$ ./tts-app
```

To connect to a server on a different port/ip

```console
$ TTS_HOST=some.host TTS_PORT=80 ./tts-app
```
