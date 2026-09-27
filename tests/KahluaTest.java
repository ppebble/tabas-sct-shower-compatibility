import java.nio.file.Files;
import java.nio.file.Path;

/** Reflection keeps compilation independent of the installed game version. */
public final class KahluaTest {
    public static void main(String[] args) throws Exception {
        Class<?> table = Class.forName("se.krka.kahlua.vm.KahluaTable");
        Class<?> platformType = Class.forName("se.krka.kahlua.vm.Platform");
        Class<?> platformClass = Class.forName("se.krka.kahlua.j2se.J2SEPlatform");
        Object platform = platformClass.getMethod("getInstance").invoke(null);
        Object environment = platformClass.getMethod("newEnvironment").invoke(platform);
        Class<?> threadType = Class.forName("se.krka.kahlua.vm.KahluaThread");
        Object thread = threadType.getConstructor(platformType, table).newInstance(platform, environment);
        threadType.getField("debugOwnerThread").set(thread, Thread.currentThread());
        Object closure = Class.forName("se.krka.kahlua.luaj.compiler.LuaCompiler")
            .getMethod("loadstring", String.class, String.class, table)
            .invoke(null, Files.readString(Path.of(args[0])), args[0], environment);
        Object[] result = (Object[]) threadType.getMethod("pcall", Object.class, Object[].class)
            .invoke(thread, closure, new Object[0]);
        if (!Boolean.TRUE.equals(result[0])) throw new AssertionError(java.util.Arrays.toString(result));
        System.out.println("PASS Kahlua behavior suite with installed TABAS source");
    }
}
