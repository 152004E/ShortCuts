{
  "model": "Gemini 3.1 Pro (High)",
  "permissions": {
    "allow": [
      "command(.*)",
      "command(cp)"
    ],
    "deny": [
      "command(^npm.*)",
      "command(^npx.*)",
      "command(^yarn.*)",
      "command(^git (push|pull|fetch|remote|commit|reset --hard|clean).*)",
      "command(^sudo.*)",
      "command(^su .*)",
      "command(^rm -rf (/|~|\\.\\.).*)",
      "command(.*\\.ssh.*)",
      "command(.*\\.gnupg.*)"
    ],
    "ask": [
      "command(^pnpm (publish|deploy).*)",
      "command(^(vercel|netlify|firebase|docker push).*)",
      "command(^(dnf|apt|pacman) .*)",
      "command(^rm .*)"
    ]
  },
  "toolPermission": "always-proceed",
  "trustedWorkspaces": [
    "/home/SenaFactory",
    "/home/SenaFactory/Documentos/MyProjects",
    "/home/SenaFactory/Documentos/MyProjects/ShortCuts",
    "/home/SenaFactory/.gemini/antigravity-cli"
  ]
}
