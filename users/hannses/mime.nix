{pkgs, globals, ...}: 
{
 xdg.mimeApps = let
    associations = {
      # https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types

      # image
      "image/png" = [ "${globals.image}.desktop" ];
      "image/jpeg" = [ "${globals.image}.desktop" ];
      "image/webp" = [ "${globals.image}.desktop" ];
      "image/gif" = [ "${globals.image}.desktop" ];
      "image/bmp" = [ "${globals.image}.desktop" ];
      "image/svg+xml" = [ "${globals.image}.desktop" ];
      "image/tiff" = [ "${globals.image}.desktop" ];
      "image/apng" = [ "${globals.image}.desktop" ];
      "image/vnd.microsoft.icon" = [ "${globals.image}.desktop" ];
      # video
      "video/mp4" = [ "${globals.video}.desktop" ];
      "video/mpeg" = [ "${globals.video}.desktop" ];
      "video/mkv" = [ "${globals.video}.desktop" ];
      "video/webm" = [ "${globals.video}.desktop" ];
      "video/ogg" = [ "${globals.video}.desktop" ];
      "video/x-msvideo" = [ "${globals.video}.desktop" ];

      # documents
      "application/pdf" = [ "${globals.pdf}.desktop" ];
      "application/msword" = [ "${globals.docs}.desktop" ];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "${globals.docs}.desktop" ];
      "application/vnd.ms-excel" = [ "${globals.docs}.desktop" ];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ "${globals.docs}.desktop" ];
      "text/csv" = [ "${globals.docs}.desktop" ];
      "application/vnd.ms-powerpoint" = [ "${globals.docs}.desktop" ];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "${globals.docs}.desktop" ];
      "application/vnd.oasis.opendocument.text" = [ "${globals.docs}.desktop" ];

      # archives
      "application/zip" = [ "${globals.archive}.desktop" ];
      "application/x-7z-compressed" = [ "${globals.archive}.desktop" ];
      "application/vnd.rar" = [ "${globals.archive}.desktop" ];
      "application/x-tar" = [ "${globals.archive}.desktop" ];
      "application/x-bzip" = [ "${globals.archive}.desktop" ];
      "application/x-bzip2" = [ "${globals.archive}.desktop" ];
      "application/gzip" = [ "${globals.archive}.desktop" ];

      #TODO
      #"inode/directory" = [ "thunar.desktop" ];
    };
  in {
    enable = true;
    associations.added = associations;
    defaultApplications = associations;
  };
}
