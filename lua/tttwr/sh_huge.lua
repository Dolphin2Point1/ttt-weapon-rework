local SWEP = weapons.GetStored("weapon_zm_sledge")

TTTWR.MakeWeapon(SWEP,
	"huge",
	"weapons/m249/m249-1.wav",
	7,
	60 / 1000,
	0.1,
	2,
	200,
	-5.95, -5.119, 2.349,
	0, 0, 0
)

SWEP.HoldType = "shotgun"

SWEP.Primary.ClipMax = 200

SWEP.ReloadTime = 5
SWEP.DeployTime = 0.75

SWEP.StoreLastPrimaryFire = true

function SWEP:PreSetupDataTables()
	self:NetworkVar("Float", 2, "Inaccuracy")
end

local remapclamp, clamp = TTTWR.RemapClamp, math.Clamp

local function getacc(self)
	return clamp(
		self:GetInaccuracy() - remapclamp(
			CurTime() - self:GetLastPrimaryFire(),
			0.12, 0.6, 0, 2000
		),
		0, 2000
	)
end

function SWEP:OnPostShoot()
	return self:SetInaccuracy(
		clamp(getacc(self) + 100, 0, 2000)
	)
end

local remap = math.Remap

function SWEP:GetPrimaryCone()
	if not self:GetIronsights() then
		return self.BaseClass.GetPrimaryCone(self)
	end

	return self.BaseClass.GetPrimaryCone(self) * remap(
		getacc(self), 0, 2000, 1, 0.05
	) * (1 / 0.85)
end

function SWEP:GetRecoilScale(sights)
	if sights then
		return remap(
			getacc(self), 0, 2000, 1, 0.125
		)
	end
end

if CLIENT then
	SWEP.Icon = "vgui/ttt/icon_m249"
end
