icon_sizes = ['16', '24', '32', '48', '64', '128']

foreach i : icon_sizes
  install_data(
    join_paths('images', 'icons', i, meson.project_name() + '.svg'),
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
  )
  install_data(
    join_paths('images', 'icons', i, meson.project_name() + '.svg'),
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps')
  )
endforeach

install_data (
    meson.project_name() + '.gschema.xml',
    install_dir: join_paths (get_option ('datadir'), 'glib-2.0', 'schemas'),
    rename: meson.project_name () + '.gschema.xml'
)

desktop_file = i18n.merge_file (
    'desktop',
    input: meson.project_name() + '.desktop.in',
    output: meson.project_name() + '.desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications'),
    po_dir: join_paths(meson.source_root (), 'po', 'extra'),
    type: 'desktop'
)

appstream_file = i18n.merge_file (
    'appdata',
    input: meson.project_name() + '.appdata.xml.in',
    output: meson.project_name() + '.appdata.xml',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo'),
    po_dir: join_paths(meson.source_root (), 'po', 'extra')
)

appstream_util = find_program('appstream-util', required: false)
if appstream_util.found()
    test ('Validate appstream file', appstream_util, args: ['validate-relax', appstream_file])
endif

desktop_file_validate = find_program('desktop-file-validate', required: false)
if desktop_file_validate.found()
    test ('Validate desktop file', desktop_file_validate, args: [ desktop_file ])
endif