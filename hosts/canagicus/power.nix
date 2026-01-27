{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    ;
in {
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  # I do not know of a better way to achieve this. What this does is reduce the
  # cpu frequency to a much lower one if the cpu gets too hot, and it waits a
  # while and if it's cooled down then it puts it back up again. One problem I
  # have with the computer that prohibits a better solution is that the cpu
  # only advertises 3 frequencies: 2.1, 1.7 and 1.4. The first is kinda a lie,
  # as it boosts up to 3.2 if set to that, but the other 2 are respected. I
  # would rather lower it to 2.4 or something but that doesn't work as it gets
  # clamped to 2.1, and therefore 3.2. I assume this is a problem that is
  # caused by the fact that the laptop refuses to boot with amd_pstate, and
  # only uses acpi-cpufreq. I think this is caused by the bios config being bad
  # (something about CPPC I read) but no such option is exposed in the bios,
  # and therefore I must settle with this.
  #
  # The reason this is necessary is because if the laptop's cpu reaches a
  # certain temperature (didn't bother to check but it's above the one set
  # below) some sort of mechanism triggers that automatically clamps down the
  # temperature to 400MHz until the system is rebooted. The scaling driver is
  # unaware of this, and therefore just lets the cpu max out at 3.2GHz under
  # load causing the "fuse" to trip. Ideally you wouldn't even need this,
  # because the laptop shouldn't get that hot, but I have not made its cooling
  # good, and therefore it gets really hot.
  systemd.services."thermal-throttle" = let
    maxTemp = 60;
    hotFreq = 1.8;
    coldFreq = 3.2;

    cpupower = config.boot.kernelPackages.cpupower;
  in {
    description = "script to throttle cpu temps to avoid tripping sensors";
    wantedBy = ["default.target"];

    serviceConfig = {
      ExecStart =
        pkgs.writeShellScriptBin "thermal-throttle"
        /*
        bash
        */
        ''
          setfreq() {
            echo "Setting freq to $1"
            ${getExe cpupower} frequency-set --max "$1GHz" >/dev/null
          }

          last_check_was_hot=false
          while true; do
            temp=$(cat /sys/class/hwmon/hwmon*/temp1_input \
                | ${pkgs.coreutils}/bin/sort --numeric-sort --reverse \
                | ${pkgs.coreutils}/bin/head -n1)

            echo "Got $temp"
            if (( temp > ${toString (maxTemp * 1000)} )); then
                if [ "$last_check_was_hot" = true ]; then
                  setfreq "${toString hotFreq}"

                  # Give it some more time to cool down
                  sleep 5
                else
                  last_check_was_hot=true
                  setfreq "${toString coldFreq}"
                fi
            else
                last_check_was_hot=false
                setfreq "${toString coldFreq}"
            fi

            sleep 5
          done
        ''
        |> getExe;
    };
  };
}
