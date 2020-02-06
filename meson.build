project ('com.github.msmaldi.spliterminal', [ 'vala', 'c'], version: '1.0.0')

i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

splittable_terminal_proj = subproject ('lib-splittable-terminal')
splittable_terminal_dep = splittable_terminal_proj.get_variable ('splittable_terminal_dependency')

granite = dependency('granite')

spliterminal_deps = [
    granite,
    splittable_terminal_dep
]

spliterminal_srcs = files(
    'src/Application.vala',
    'src/Widgets/LoadingBox.vala',
    'src/Widgets/WorkspaceStack.vala',
    'src/Widgets/WorkspaceSwitcher.vala',
    'src/Widgets/HeaderBar.vala',
)

executable(meson.project_name(), spliterminal_srcs,
    dependencies: spliterminal_deps,
    install : true
)

subdir('data')

meson.add_install_script('meson/post_install.py')