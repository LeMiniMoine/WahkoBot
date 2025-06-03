from .testcmd import TestCmd

async def setup(bot):
    await bot.add_cog(TestCmd(bot))
