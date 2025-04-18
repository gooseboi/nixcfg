{
  environment.shellAliases = {
    sc = "systemctl";
    sct = "systemctl stop";
    scr = "systemctl restart";
    scs = "systemctl status";
    scst = "systemctl start";
    scu = "systemctl --user";
    scut = "systemctl --user stop";
    scur = "systemctl --user restart";
    scus = "systemctl --user status";
    scust = "systemctl --user start";

    jc = "journalctl";
    jcf = "journalctl --follow --unit";
    jcr = "journalctl --reverse --unit";
    jce = "journalctl --pager-end --unit";
    jcu = "journalctl --user";
    jcuf = "journalctl --user --follow --unit";
    jcur = "journalctl --user --reverse --unit";
    jcue = "journalctl --user --bpager-end --unit";
  };
}
