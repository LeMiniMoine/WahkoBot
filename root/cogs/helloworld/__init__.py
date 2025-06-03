from .helloworld import HelloWorld

async def setup(bot):
    await bot.add_cog(HelloWorld(bot))
