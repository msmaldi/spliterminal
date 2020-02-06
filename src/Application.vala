/* Application.vala
 *
 * Copyright 2019 Matheus Maldi
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
public class Spliterminal.Application : Gtk.Application
{
    public static GLib.Settings saved_state;
    public static GLib.Settings settings;
    public static GLib.Settings settings_sys;

    private const int NORMAL = 0;
    private const int MAXIMIZED = 1;
    private const int FULLSCREEN = 2;

    static construct {
        saved_state = new GLib.Settings ("com.github.msmaldi.spliterminal.saved-state");
        //settings = new GLib.Settings ("com.github.msmaldi.spliterminal.settings");
        //settings_sys = new GLib.Settings ("org.gnome.desktop.interface");
    }


    public Application ()
    {
        Object (
            application_id: "com.github.msmaldi.spliterminal",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    private WorkspaceStack stack;
    private Gtk.ApplicationWindow window;

    protected override void activate ()
    {
        if (window != null)
        {
            window.present ();
            return;
        }
        window = new Gtk.ApplicationWindow (this);

        var rect = Gdk.Rectangle ();
        saved_state.get ("window-size", "(ii)", out rect.width, out rect.height);

        var default_width = rect.width;
        var default_height = rect.height;

        window.set_size_request (1366, 700);
        if (default_width != -1 || default_height != -1)
            window.resize (default_width, default_height);
        else
            window.resize (1300, 700);

        var window_state = saved_state.get_enum ("window-state");
        if (window_state == MAXIMIZED)
            window.maximize ();

        var headerbar = new HeaderBar ();
        window.set_titlebar (headerbar);

        stack = new WorkspaceStack ();
        var switcher = new WorkspaceSwitcher (stack);

        headerbar.pack_start (switcher);
        window.key_press_event.connect(key_press);

        window.configure_event.connect (on_window_state_change);
        window.delete_event.connect (delete_event);

        configure_workspace();
    }

    protected bool delete_event (Gdk.EventAny event) {
        for (int i = 1; i <= 10; i++)
        {
            var workspace = stack.workspaces[i % 10];
            var wk_str = "workspace%d".printf(i % 10);
            saved_state.set (wk_str, "s", workspace.to_compact_string ());
        }

        string child_name = stack.visible_child_name;
        saved_state.set ("focused-stack", "s", child_name);

        return false;
    }

    private void configure_workspace ()
    {
        for (int i = 1; i <= 10; i++)
        {
            string workspace_config;
            saved_state.get ("workspace%d".printf(i % 10), "s", out workspace_config);
            var workspace = new Workspace (workspace_config);
            stack.workspaces[i % 10] = workspace;
            stack.add_titled (workspace, "alt%d".printf (i % 10), "Alt + %d".printf(i % 10));
        }
        window.add (stack);
        window.show_all ();

        string focused_workspace;
        saved_state.get ("focused-stack", "s", out focused_workspace);

        stack.set_visible_child_name (focused_workspace);
    }

    private uint timer_window_state_change = 0;
    private bool on_window_state_change (Gdk.EventConfigure event)
    {
        // triggered when the size, position or stacking of the window has changed
        // it is delayed 400ms to prevent spamming gsettings
        if (timer_window_state_change > 0)
            GLib.Source.remove (timer_window_state_change);

        timer_window_state_change = GLib.Timeout.add (400, () =>
        {
            timer_window_state_change = 0;
            if (window == null)
                return false;

            //  Todo: support full screen
            //  if ((window.get_state () & Gdk.WindowState.FULLSCREEN) != 0)
            //      Application.saved_state.set_enum ("window-state", FULLSCREEN);
            //  else
            if (window.is_maximized)
                Application.saved_state.set_enum ("window-state", MAXIMIZED);
            else
            {
                Application.saved_state.set_enum ("window-state", NORMAL);

                var rect = Gdk.Rectangle ();
                window.get_size (out rect.width, out rect.height);
                Application.saved_state.set ("window-size", "(ii)", rect.width, rect.height);

                int root_x, root_y;
                window.get_position (out root_x, out root_y);
                Application.saved_state.set ("window-position", "(ii)", root_x, root_y);
            }

            return false;
        });

        return false;
    }

    public bool key_press (Gdk.EventKey event)
    {
        if ((event.state & Gdk.ModifierType.MOD1_MASK) != 0)
        {
            unichar key_unicode = Gdk.keyval_to_unicode(Gdk.keyval_to_lower(event.keyval));
            if ('0' <= key_unicode <= '9')
            {
                string child_name = "alt%c".printf((char)key_unicode);
                stack.set_visible_child_name (child_name);
                stack.workspaces[key_unicode - '0'].grab_focus ();
                return true;
            }
        }
        return false;
    }

    private static int main (string[] args)
    {
        var app = new Application ();
        return app.run (args);
    }
}