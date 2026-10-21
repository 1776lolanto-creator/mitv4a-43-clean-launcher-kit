# Notice and upstream attribution

This repository is a device-specific companion kit for Xiaomi MiTV4A 43
(`matrix`, Android 6.0.1 / API 23). It documents and automates a setup built
around the open-source `cleanyourtv` launcher by Gathin23:

- https://github.com/Gathin23/cleanyourtv
- Upstream license: MIT

This repository does **not** vendor the upstream launcher source or its font
assets. The launcher package name used by the tested setup is
`com.gathin.tvhome`.

Xiaomi, Mi TV, Android, Google TV and other product names are trademarks of
their respective owners. This project is independent and is not affiliated
with or endorsed by Xiaomi, Google, Bilibili, or the upstream project.

## v1.1.0 device adaptation code

The `HomeGuard.java` and `HomeGuardReceiver.java` files under `patches/homeguard/`
are original device-specific adaptation code included by this repository under
the repository's MIT License. They are not claimed to be upstream `cleanyourtv`
source files.
