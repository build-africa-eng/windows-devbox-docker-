group "default" {
  targets = ["windows-devbox"]
}

target "windows-devbox" {
  dockerfile = "Dockerfile"
  context    = "."
  tags       = ["windows-devbox:latest"]
  output     = ["type=docker"]
  platforms  = ["windows/amd64"]
}