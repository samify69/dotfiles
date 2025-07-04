animations {
    enabled = yes

    # 🔁 Custom Beziers for silky smooth feel
    bezier = wind, 0.25, 1, 0.3, 1
    bezier = winIn, 0.4, 0.0, 0.2, 1
    bezier = winOut, 0.5, 0.1, 0.3, 1
    bezier = smooth, 0.3, 0.7, 0.4, 1
    bezier = liner, 1, 1, 1, 1

    # 🎬 Smoothest motion experience
    animation = windows, 1, 7, smooth, slidefade
    animation = windowsIn, 1, 8, winIn, slide
    animation = windowsOut, 1, 6, winOut, slide
    animation = windowsMove, 1, 6, wind, slide

    # 🔲 Borders and fades
    animation = border, 1, 2, liner
    animation = borderangle, 1, 40, liner, loop
    animation = fade, 1, 10, smooth

    # 🔄 Workspaces transitions
    animation = workspaces, 1, 7, wind
}
