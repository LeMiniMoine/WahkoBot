import aiohttp
from redbot.core import commands, tasks
import logging

log = logging.getLogger("red.keeplive")

class KeepAlive(commands.Cog):
    """Keep the Render app awake by pinging its own URL."""

    def __init__(self, bot):
        self.bot = bot
        self.keep_alive.start()

    def cog_unload(self):
        self.keep_alive.cancel()

    @tasks.loop(minutes=10)
    async def keep_alive(self):
        url = "https://wahkobot.onrender.com"
        try:
            async with aiohttp.ClientSession() as session:
                async with session.get(url) as resp:
                    log.info(f"[KeepAlive] Ping sent. Status: {resp.status}")
        except Exception as e:
            log.warning(f"[KeepAlive] Ping failed: {e}")

    @keep_alive.before_loop
    async def before_keep_alive(self):
        await self.bot.wait_until_ready()
