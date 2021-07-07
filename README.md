# Photo Channel

This project executes a sequence of plugins to process and classify photos with the purpose to generate image galleries.

## How to use

Rename `config.conf.sample` to `config.conf` and choose what plugins you like to use. Now run `./photo-channel.sh` and wait. This process can take a long time if you have a lot of photos.

## Plugins

There are three types of plugins

### Source Plugins

Source plugins reads from a source, like a folder or a image hosting site and sends the image content to the next plugin in the chain, the Process Plugins.

#### Output

Send one or more JSON objects that contains one key called `data`, data should contain a base64 encoded representation of the images binary data. The plugins are free to add additional keys, like for example the [plugin-source-folder](https://github.com/photo-channel/plugin-source-folder) source plugin will also add the images original path to a source key.

```
{"data": "<base64 encoded data>"}
```

* [List of official source plugins](https://github.com/photo-channel?q="plugin-source")

### Process Plugins

These plugins are executed in order for each and every image. They can do anything they like with the payload. The payload is sent via STDIN and the modified payload should be sent to STDOUT.

Plugins may require other plugins to be executed before them. For example a face recognition may only support JPEG-images, so a plugin that converts all non-JPEG images should be executed before.

* [List of official process plugins](https://github.com/photo-channel?q="plugin-process")

### Output Plugins

These plugins will read the final payload from STDIN and write them to some place, it could be a image galley, a system directory or anything that the plugin supports. Plugins should also echo out the payload to STDOUT for other plugins to consume.

* [List of official output plugins](https://github.com/photo-channel?q="plugin-output")

## Common keys

You are free to modify and do whatever you like with any key, but to make plugin compatibility better here are a few standardized keys that all official plugins follows.

### data

Base64 encoded binary data of the source image.
