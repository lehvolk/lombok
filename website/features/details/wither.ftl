<#import "../../freemarker/main-template.ftl" as u>

<@u.page>
<div class="page-header top5">
    <div class="row text-center">
        <div class="header-group">
            <h1>@Wither</h1>

            <h3>Immutable 'setters' - methods that create a clone but with one changed field.</h3>

            <p>
                @Wither was introduced as experimental feature in lombok v0.11.4.
            </p>
        </div>
    </div>
    <div class="row">
        <h3>Experimental</h3>

        <p>
            Experimental because:
        <ul>
            <li>Still not sure that <code>@Wither</code> is an appropriate name for this feature.</li>
            <li>Should there be an option to supply a way of cloning the input somehow?</li>
            <li>Should the way that the clone is created by configurable?</li>
            <li>Should we replace @Wither entirely with a builder class?</li>
        </ul>
        Current status: <em>neutral</em> - More feedback requires on the items in the above list before promotion to
        the main package is warranted.
    </div>
    <div class="overview">
        <h3>Overview</h3>

        <p>
            The next best alternative to a setter for an immutable property is to construct a clone of the object,
            but with a new value for this one field.
            A method to generate this clone is precisely what <code>@Wither</code> generates: a
            <code>withFieldName(newValue)</code>
            method which produces a clone
            except for the new value for the associated field.
        </p>

        <p>
            For example, if you create <code>public class Point { private final int x, y; }</code>, setters make no
            sense because the fields
            are final. <code>@Wither</code> can generate a <code>withX(int newXValue)</code> method for you which
            will return a new point with the supplied
            value for <code>x</code> and the same value for <code>y</code>.
        </p>

        <p>
            Like <a href="/features/details/getter-setter.html"><code>@Setter</code></a>, you can specify an access level in
            case
            you want the generated wither to be something other than <code>public</code>:<br/>
            <code>@Wither(level = AccessLevel.PROTECTED)</code>. Also like <a
                href="/features/details/getter-setter.html"><code>@Setter</code></a>,
            you can also put a <code>@Wither</code> annotation on a type, which means
            a 'wither' is generated for each field (even non-final fields).
        </p>

        <p>
            To put annotations on the generated method, you can use <code>onMethod=@__({@AnnotationsHere})</code>;
            to put annotations on the only parameter of a generated wither method, you can use <code>onParam=@__({@AnnotationsHere})</code>.
            Be careful though! This is an experimental feature. For more details see the documentation on the <a
                href="/features/details/on-x.html">onX</a> feature.
        </p>

        <p>
            <em>NEW in lombok v1.12.0:</em> javadoc on the field will now be copied to generated withers. Normally,
            all text is copied, and <code>@param</code> is <em>moved</em> to the wither, whilst <code>@return</code>
            lines are stripped from the wither's javadoc. Moved means: Deleted from the field's javadoc. It is also
            possible to define unique text for the wither's javadoc. To do that, you create a 'section' named
            <code>WITHER</code>.
            A section is a line in your javadoc containing 2 or more dashes, then the text 'WITHER', followed by 2
            or more dashes, and nothing else on the line. If you use sections, <code>@return</code> and
            <code>@param</code> stripping / copying for that section is no longer done (move the <code>@param</code>
            line into the section).
        </p>
    </div>
    <@u.comparison />
    <div class="row">
        <h3>Supported configuration keys:</h3>
        <dl>
            <dt><code>lombok.wither.flagUsage</code> = [<code>warning</code> | <code>error</code>] (default: not
                set)
            </dt>
            <dd>Lombok will flag any usage of <code>@Wither</code> as a warning or error if configured.</dd>
        </dl>
    </div>
    <div class="row">
        <h3>Small print</h3>

        <div class="smallprint">
            <p>
                Withers cannot be generated for static fields because that makes no sense.
            </p>

            <p>
                When applying <code>@Wither</code> to a type, static fields and fields whose name start with a $ are
                skipped.
            </p>

            <p>
                For generating the method names, the first character of the field, if it is a lowercase character,
                is title-cased, otherwise, it is left unmodified.
                Then, <code>with</code> is prefixed.
            </p>

            <p>
                No method is generated if any method already exists with the same name (case insensitive) and same
                parameter count. For example, <code>withX(int x)</code>
                will not be generated if there's already a method <code>withX(String... x)</code> even though it is
                technically possible to make the method. This caveat
                exists to prevent confusion. If the generation of a method is skipped for this reason, a warning is
                emitted instead. Varargs count as 0 to N parameters.
            </p>

            <p>
                For <code>boolean</code> fields that start with <code>is</code> immediately followed by a title-case
                letter, nothing is prefixed to generate the wither name.
            </p>

            <p>
                Any annotations named <code>@NonNull</code> (case insensitive) on the field are interpreted as: This
                field must not ever hold
                <em>null</em>. Therefore, these annotations result in an explicit null check in the generated
                wither. Also, these
                annotations (as well as any annotation named <code>@Nullable</code> or <code>@CheckForNull</code>)
                are copied to wither parameter.
            </p>
        </div>
    </div>
</div>
</@u.page>

