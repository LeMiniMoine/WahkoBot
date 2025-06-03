import discord
from redbot.core import commands

class HelloWolrd(commands.Cog):
    """A simple test command cog."""

    def __init__(self, bot):
        self.bot = bot

    @commands.command()
    async def hello(self, ctx):
        """Replies with a friendly hello."""
        await ctx.send("👋 Hello! The cog is working correctly.")
