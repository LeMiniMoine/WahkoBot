from redbot.core import commands, data_manager
import json
import os

from .setupserver import SetupServer

async def setup(bot):
    bot.add_cog(SetupServer(bot))
