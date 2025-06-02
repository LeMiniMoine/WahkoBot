from redbot.core import commands
import discord

class SetupServer(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @commands.command(name="setupserver")
    @commands.guild_only()
    @commands.has_permissions(administrator=True)
    async def setup_server(self, ctx):
        """Crée la structure du serveur Discord WahkoLab."""
        guild = ctx.guild
        await ctx.send("🚧 Configuration du serveur en cours...")

        # ⬆️ ROLES
        roles = [
            ("Founder", discord.Permissions(administrator=True)),
            ("Core Team", discord.Permissions(manage_channels=True, manage_messages=True)),
            ("Contributor", discord.Permissions(send_messages=True, read_messages=True)),
            ("Visitor", discord.Permissions(read_messages=True)),
        ]
        for name, perms in roles:
            if not discord.utils.get(guild.roles, name=name):
                await guild.create_role(name=name, permissions=perms)

        # 📂 CATEGORY + CHANNEL HELPERS
        async def create_category(name):
            return await guild.create_category(name)

        async def create_text_channel(cat, name, overwrites=None):
            return await guild.create_text_channel(name, category=cat, overwrites=overwrites)

        read_only_overwrites = {
            guild.default_role: discord.PermissionOverwrite(send_messages=False, read_messages=True)
        }

        # 📄 Welcome
        welcome_cat = await create_category("Welcome")
        await create_text_channel(welcome_cat, "welcome", read_only_overwrites)
        await create_text_channel(welcome_cat, "rules", read_only_overwrites)
        await create_text_channel(welcome_cat, "whitepaper", read_only_overwrites)
        await create_text_channel(welcome_cat, "manifesto", read_only_overwrites)
        await create_text_channel(welcome_cat, "readings", read_only_overwrites)
        await create_text_channel(welcome_cat, "start-here")

        # 💬 General
        general_cat = await create_category("General Discussion")
        await create_text_channel(general_cat, "chat-fr")
        await create_text_channel(general_cat, "chat-en")

        # 🛠 WahkoLab Development
        dev_cat = await create_category("WahkoLab Development")
        await create_text_channel(dev_cat, "announcements", read_only_overwrites)
        await create_text_channel(dev_cat, "dev-updates")
        await create_text_channel(dev_cat, "governance-lab")
        await create_text_channel(dev_cat, "tech-lab")
        await create_text_channel(dev_cat, "feedback")

        # 🗂 WahkoLab Projects
        projects_cat = await create_category("WahkoLab Projects")
        paperwars_cat = await create_category("Paper Wars")
        await create_text_channel(paperwars_cat, "introduction", read_only_overwrites)
        await create_text_channel(paperwars_cat, "paperwars-general")
        await create_text_channel(paperwars_cat, "paperwars-design")
        await create_text_channel(paperwars_cat, "paperwars-dev")
        await create_text_channel(paperwars_cat, "paperwars-governance")
        await create_text_channel(paperwars_cat, "paperwars-feedback")

        # 🔐 Core Team
        private_cat = await create_category("Core Team (Private)")
        await create_text_channel(private_cat, "core-chat")
        await create_text_channel(private_cat, "moderation")
        await create_text_channel(private_cat, "bot-logs")

        await ctx.send("🚀 Structure du serveur WahkoLab créée avec succès !")
