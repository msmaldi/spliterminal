/* HeaderBar.vala
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
public class Spliterminal.HeaderBar : Gtk.HeaderBar
{
    public HeaderBar ()
    {
        get_style_context ().add_class ("default-decoration");
        show_close_button = true;

        var gtk_settings = Gtk.Settings.get_default ();

        bool dark_theme;
        Application.saved_state.get ("dark-theme", "b", out dark_theme);
        gtk_settings.gtk_application_prefer_dark_theme = dark_theme;

        var mode_switch = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic", "weather-clear-night-symbolic");
        mode_switch.active = dark_theme;
        mode_switch.primary_icon_tooltip_text = ("Light background");
        mode_switch.secondary_icon_tooltip_text = ("Dark background");
        mode_switch.valign = Gtk.Align.CENTER;
        mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
        mode_switch.margin_end = 6;
        mode_switch.notify["active"].connect (() => {
            Application.saved_state.set ("dark-theme", "b", mode_switch.active);
        });
        pack_end (mode_switch);

        var search_entry = new Gtk.SearchEntry ();
        search_entry.valign = Gtk.Align.CENTER;
        //search_entry.hexpand = true;
        pack_end (search_entry);
    }

}