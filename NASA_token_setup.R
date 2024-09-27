# Setting up the NASA Earth Data Token

file.create(".netrc")


sink(".netrc")
writeLines(
  "machine urs.earthdata.nasa.gov login messierkp password LoJB39ak-2UozTU*R83p"
)
sink()

system("chmod 0600 .netrc")

file.create(".urs_cookies")

file.create(".dodsrc")


sink(".dodsrc")
writeLines(
  paste0(
    "HTTP.NETRC=mnt/.netrc\n",
    "HTTP.COOKIE.JAR=mnt/.urs_cookies"
  )
)
sink()