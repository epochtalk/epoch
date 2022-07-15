alias Epoch.Role

roles = [
  %{
    id: 1,
    name: "Super Administrator",
    lookup: "superAdministrator",
    description: "Full moderation and settings access",
    priority: 0,
    highlight_color: "#FF7442",
    base_permissions: %{},
    custom_permissions: %{}
  },
  %{
    id: 2,
    name: "Administrator",
    lookup: "administrator",
    description: "Full moderation and partial settings access",
    priority: 1,
    highlight_color: "#FF4C4C",
    base_permissions: %{},
    custom_permissions: %{}
  },
  %{
    id: 3,
    name: "Global Moderator",
    lookup: "globalModerator",
    description: "Full moderation access across all boards",
    priority: 2,
    highlight_color: "#32A56E",
    base_permissions: %{},
    custom_permissions: %{},
  },
  %{
    id: 4,
    name: "Moderator",
    lookup: "moderator",
    description: "Full moderation access to moderated boards",
    priority: 3,
    highlight_color: "",
    base_permissions: %{},
    custom_permissions: %{}
  },
  %{
    id: 5,
    name: "User",
    lookup: "user",
    description: "Standard account with access to create threads and post",
    priority: 4,
    base_permissions: %{},
    custom_permissions: %{}
  },
  %{
    id: 6,
    name: "Patroller",
    lookup: "patroller",
    description: "Moderates Newbies only, otherwise mirrors User role unless modified",
    priority: 5,
    base_permissions: %{},
    custom_permissions: %{}
  },
  %{
    id: 7,
    name: "Newbie",
    lookup: "newbie",
    description: "Brand new users",
    priority: 6,
    base_permissions: %{},
    custom_permissions: %{}
  },
  %{
    id: 8,
    name: "Banned",
    lookup: "banned",
    description: "Read only access with content creation disabled",
    priority: 7,
    # priority_restrictions: [0, 1, 2, 3],
    base_permissions: %{},
    custom_permissions: %{}
  },
  %{
    id: 9,
    name: "Anonymous",
    lookup: "anonymous",
    description: "Read only access",
    priority: 8,
    base_permissions: %{},
    custom_permissions: %{}
  },
  %{
    id: 10,
    name: "Private",
    lookup: "private",
    description: "Role assigned to unauthorized users when public forum is disabled",
    priority: 9,
    base_permissions: %{},
    custom_permissions: %{}
  }
]

roles
|> Role.insert
