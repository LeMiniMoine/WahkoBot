from .keepalive import KeepAlive

def setup(bot):
    bot.add_cog(KeepAlive(bot))
