public class SpeakerWindow : Gtk.Window {
    private Gtk.Entry entry;
    private Gtk.Button button;
    private Gtk.EventControllerKey controller;

    public SpeakerWindow () {
        title = "TTS";
        resizable = false;

        create_layout ();

        controller = new Gtk.EventControllerKey();
        controller.key_pressed.connect(this.key_press_cb);
        child.add_controller(controller);
    }

    private void say() {
        var host = Environment.get_variable("TTS_HOST");
        if (host == null) {
          host = "localhost";
        }
        var port = Environment.get_variable("TTS_PORT");
        if (port == null) {
          port = "5002";
        }
        var uri = new Gst.Uri ("http", null, host, int.parse(port), "/api/tts", "text=" + entry.text, null);

        stderr.printf("request: %s\n", uri.to_string());
        try {
            var pipeline = Gst.parse_launchv ({"playbin", "uri=" + uri.to_string()});
            pipeline.set_state (Gst.State.PLAYING);
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }

    private void create_layout () {
        entry = new Gtk.Entry ();
        entry.width_chars = 80;
        entry.placeholder_text = "Say something";
        entry.activate.connect(say);

        button = new Gtk.Button.with_label ("Say!");
        button.clicked.connect(say);

        var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
        hbox.append (entry);
        hbox.append (button);

        child = hbox;
    }

    private bool key_press_cb (Gtk.EventControllerKey controller, uint keyval, uint keycode, Gdk.ModifierType mod_state) {
        switch (Gdk.keyval_name (keyval)) {
        case "Escape":
            application.quit();
            break;
        }
        return false;
    }
}


int main(string[] args) {
    Gst.init (ref args);

    var app = new Gtk.Application ("io.thalheim.tts", GLib.ApplicationFlags.FLAGS_NONE);
    app.activate.connect (() => {
      var sw = new SpeakerWindow();
      sw.application = app;
      sw.present ();
    });
    return app.run(args);
}
