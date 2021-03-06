<#import "../../freemarker/main-template.ftl" as u>

<@u.page>
<div class="page-header top5">
    <div class="row text-center">
        <div class="header-group">
            <h1>@Builder</h1>

            <h3>... and Bob's your uncle: No-hassle fancy-pants APIs for object creation!</h3>

            <p>
                <code>@Builder</code> was introduced as experimental feature in lombok v0.12.0.
            </p>

            <p>
                <code>@Builder</code> gained <code>@Singular</code> support and was promoted to the main
                <code>lombok</code> package since lombok v1.16.0.
            </p>
        </div>
    </div>
    <div class="row">
        <div class="overview">
            <h3>Overview</h3>

            <p>
                The <code>@Builder</code> annotation produces complex builder APIs for your classes.
            </p>

            <p>
                <code>@Builder</code> lets you automatically produce the code required to have your class be
                instantiable with
                code such as:<br/>
                <code>Person.builder().name("Adam Savage").city("San Francisco").job("Mythbusters").job("Unchained
                    Reaction").build();</code>
            </p>

            <p>
                <code>@Builder</code> can be placed on a class, or on a constructor, or on a static method. While
                the "on a
                class" and "on a constructor"
                mode are the most common use-case, <code>@Builder</code> is most easily explained with the "static
                method"
                use-case.
            </p>

            <p>
                A static method annotated with <code>@Builder</code> (from now on called the <em>target</em>) causes
                the
                following 7 things to be generated:
            <ul>
                <li>An inner static class named <code><em>Foo</em>Builder</code>, with the same type arguments as
                    the static
                    method (called the <em>builder</em>).
                </li>
                <li>In the <em>builder</em>: One private non-static non-final field for each parameter of the
                    <em>target</em>.
                </li>
                <li>In the <em>builder</em>: A package private no-args empty constructor.</li>
                <li>In the <em>builder</em>: A 'setter'-like method for each parameter of the <em>target</em>: It
                    has the same
                    type as that parameter and the same name.
                    It returns the builder itself, so that the setter calls can be chained, as in the above example.
                </li>
                <li>In the <em>builder</em>: A <code>build()</code> method which calls the static method, passing in
                    each field.
                    It returns the same type that the
                    <em>target</em> returns.
                </li>
                <li>In the <em>builder</em>: A sensible <code>toString()</code> implementation.</li>
                <li>In the class containing the <em>target</em>: A <code>builder()</code> method, which creates a
                    new instance
                    of the <em>builder</em>.
                </li>
            </ul>
            Each listed generated element will be silently skipped if that element already exists (disregarding
            parameter counts
            and looking only at names). This
            includes the <em>builder</em> itself: If that class already exists, lombok will simply start injecting
            fields and
            methods inside this already existing
            class, unless of course the fields / methods to be injected already exist. You may not put any other
            method (or
            constructor) generating lombok annotation
            on a builder class though; for example, you can not put <code>@EqualsAndHashCode</code> on the builder
            class.
            <p>
                <code>@Builder</code> can generate so-called 'singular' methods for collection parameters/fields. These
                take 1
                element instead of an entire list, and add the
                element to the list. For example: <code>Person.builder().job("Mythbusters").job("Unchained
                Reaction").build();</code> would result in the <code>List&lt;String&gt; jobs</code>
                field to have 2 strings in it. To get this behaviour, the field/parameter needs to be annotated with
                <code>@Singular</code>. The feature has <a href="#singular">its own documentation</a>.
            </p>

            <p>
                Now that the "static method" mode is clear, putting a <code>@Builder</code> annotation on a
                constructor
                functions similarly; effectively,
                constructors are just static methods that have a special syntax to invoke them: Their 'return type'
                is the class
                they construct, and their
                type parameters are the same as the type parameters of the class itself.
            </p>

            <p>
                Finally, applying <code>@Builder</code> to a class is as if you added <code>@AllArgsConstructor(access
                =
                AccessLevel.PACKAGE)</code> to the class and applied the
                <code>@Builder</code> annotation to this all-args-constructor. This only works if you haven't
                written any
                explicit constructors yourself. If you do have an
                explicit constructor, put the <code>@Builder</code> annotation on the constructor instead of on the
                class.
            </p>

            <p>
                The name of the builder class is <code><em>Foobar</em>Builder</code>, where <em>Foobar</em> is the
                simplified,
                title-cased form of the return type of the
                <em>target</em> - that is, the name of your type for <code>@Builder</code> on constructors and
                types, and the
                name of the return type for <code>@Builder</code>
                on static methods. For example, if <code>@Builder</code> is applied to a class named <code>com.yoyodyne.FancyList&lt;T&gt;</code>,
                then the builder name will be
                <code>FancyListBuilder&lt;T&gt;</code>. If <code>@Builder</code> is applied to a static method that
                returns
                <code>void</code>, the builder will be named
                <code>VoidBuilder</code>.
            </p>

            <p>
                The configurable aspects of builder are:
            <ul>
                <li>The <em>builder's class name</em> (default: return type + 'Builder')</li>
                <li>The <em>build()</em> method's name (default: <code>"build"</code>)</li>
                <li>The <em>builder()</em> method's name (default: <code>"builder"</code>)</li>
            </ul>
            Example usage where all options are changed from their defaults:<br/>
            <code>@Builder(builderClassName = "HelloWorldBuilder", buildMethodName = "execute", builderMethodName =
                "helloWorld")</code><br/>

        </div>
        <div class="overview">
            <h3><a name="singular">@Singular</a></h3>

            <p>
                By annotating one of the parameters (if annotating a static method or constructor with
                <code>@Builder</code>)
                or
                fields (if annotating a class with <code>@Builder</code>) with the
                <code>@Singular</code> annotation, lombok will treat that builder node as a collection, and it
                generates 2
                'adder' methods instead of a 'setter' method. One which adds a single element to the collection, and
                one
                which adds all elements of another collection to the collection. No setter to just set the
                collection (replacing
                whatever was already added) will be generated. These 'singular' builders
                are very complicated in order to guarantee the following properties:
            <ul>
                <li>When invoking <code>build()</code>, the produced collection will be immutable.</li>
                <li>Calling one of the 'adder' methods after invoking <code>build()</code> does not modify any
                    already generated
                    objects, and, if <code>build()</code> is later called again, another collection with all the
                    elements added
                    since the creation of the builder is generated.
                </li>
                <li>The produced collection will be compacted to the smallest feasible format while remaining
                    efficient.
                </li>
            </ul>
            <p>
                <code>@Singular</code> can only be applied to collection types known to lombok. Currently, the supported
                types are:
            <ul>
                <li>
                    <a href="http://docs.oracle.com/javase/8/docs/api/java/util/package-summary.html"><code>java.util</code></a>:
                    <ul>
                        <li><code>Iterable</code>, <code>Collection</code>, and <code>List</code> (backed by a
                            compacted
                            unmodifiable <code>ArrayList</code> in the general case).
                        </li>
                        <li><code>Set</code>, <code>SortedSet</code>, and <code>NavigableSet</code> (backed by a
                            smartly sized
                            unmodifiable <code>HashSet</code> or <code>TreeSet</code> in the general case).
                        </li>
                        <li><code>Map</code>, <code>SortedMap</code>, and <code>NavigableMap</code> (backed by a
                            smartly sized
                            unmodifiable <code>HashMap</code> or <code>TreeMap</code> in the general case).
                        </li>
                    </ul>
                </li>
                <li><a href="https://github.com/google/guava">Guava</a>'s <code>com.google.common.collect</code>:
                    <ul>
                        <li><code>ImmutableCollection</code> and <code>ImmutableList</code> (backed by the builder
                            feature of
                            <code>ImmutableList</code>).
                        </li>
                        <li><code>ImmutableSet</code> and <code>ImmutableSortedSet</code> (backed by the builder
                            feature of
                            those types).
                        </li>
                        <li><code>ImmutableMap</code>, <code>ImmutableBiMap</code>, and
                            <code>ImmutableSortedMap</code> (backed
                            by the builder feature of those types).
                        </li>
                    </ul>
                </li>
            </ul>
            <p>
                If your identifiers are written in common english, lombok assumes that the name of any collection with
                <code>@Singular</code>
                on it is an english plural and will attempt to automatically
                singularize that name. If this is possible, the add-one method will use this name. For example, if your
                collection
                is called <code>statuses</code>, then the add-one method will automatically
                be called <code>status</code>. You can also specify the singular form of your identifier explictly by
                passing the
                singular form as argument to the annotation like so: <code>@Singular("axis") List&lt;Line&gt;
                axes;</code>.<br/>
                If lombok cannot singularize your identifier, or it is ambiguous, lombok will generate an error and
                force you to
                explicitly specify the singular name.
            </p>

            <p>
                The snippet below does not show what lombok generates for a <code>@Singular</code> field/parameter
                because it is
                rather complicated.
                You can view a snippet <a href="singular.ftl">here</a>.
            </p>
        </div>
        <@u.comparison />
        <div class="row">
            <h3>Supported configuration keys:</h3>
            <dl>
                <dt><code>lombok.builder.flagUsage</code> = [<code>warning</code> | <code>error</code>] (default:
                    not set)
                </dt>
                <dd>Lombok will flag any usage of <code>@Builder</code> as a warning or error if configured.</dd>
                <dt><code>lombok.singular.useGuava</code> = [<code>true</code> | <code>false</code>] (default:
                    false)
                </dt>
                <dd>If <code>true</code>, lombok will use guava's <code>ImmutableXxx</code> builders and types to
                    implement
                    <code>java.util</code> collection interfaces, instead of creating
                    implementations based on <code>Collections.unmodifiableXxx</code>. You must ensure that guava is
                    actually
                    available on the classpath and buildpath if you use this setting.
                    Guava is used automatically if your field/parameter has one of the guava
                    <code>ImmutableXxx</code> types.
                <dt><code>lombok.singular.auto</code> = [<code>true</code> | <code>false</code>] (default: true)
                </dt>
                <dd>If <code>true</code> (which is the default), lombok automatically tries to singularize your
                    identifier name
                    by assuming that it is a common english plural.
                    If <code>false</code>, you must always explicitly specify the singular name, and lombok will
                    generate an
                    error if you don't (useful if you write your code in a language other than english).
            </dl>
        </div>
        <div class="overview">
            <h3>Small print</h3>

            <div class="smallprint">
                <p>
                    @Singular support for <code>java.util.NavigableMap/Set</code> only works if you are compiling
                    with JDK1.8 or
                    higher.
                </p>

                <p>
                    You cannot manually provide some or all parts of a <code>@Singular</code> node; the code lombok
                    generates is
                    too complex for this. If you want to
                    manually control (part of) the builder code associated with some field or parameter, don't use
                    <code>@Singular</code>
                    and add everything you need manually.
                </p>

                <p>
                    The sorted collections (java.util: <code>SortedSet</code>, <code>NavigableSet</code>, <code>SortedMap</code>,
                    <code>NavigableMap</code> and guava: <code>ImmutableSortedSet</code>,
                    <code>ImmutableSortedMap</code>)
                    require that the type argument of the collection has natural order (implements
                    <code>java.util.Comparable</code>). There is no way to pass an explicit <code>Comparator</code>
                    to use in
                    the builder.
                </p>

                <p>
                    An <code>ArrayList</code> is used to store added elements as call methods of a
                    <code>@Singular</code> marked
                    field, if the target collection is from the <code>java.util</code> package, <em>even if the
                    collection is a
                    set or map</em>. Because lombok ensures that generated collections are compacted, a new backing
                    instance of
                    a set or map must be constructed anyway, and storing the data as an <code>ArrayList</code>
                    during the build
                    process is more efficient that storing it as a map or set. This behaviour is not externally
                    visible, an an
                    implementation detail of the current implementation of the <code>java.util</code> recipes for
                    <code>@Singular
                        @Builder</code>.
                </p>
            </div>
        </div>
    </div>
</div>
</@u.page>
