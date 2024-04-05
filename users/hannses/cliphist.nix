{ pkgs, ... }:
{
    services.cliphist = {
	enable = true;
	
	systemdTarget = "hyprland-session.target";
    };
}
