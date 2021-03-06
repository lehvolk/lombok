<#import "../../freemarker/main-template.ftl" as u>

<@u.page>
<div class="page-header top5">
    <div class="row text-center">
        <div class="header-group">
            <h1>@ToString</h1>

            <h3>No need to start a debugger to see your fields: Just let lombok generate a <code>
                toString</code> for you!
            </h3>
        </div>
    </div>
    <div class="row">
        <h3>Overview</h3>

        <p>
            Any class definition may be annotated with <code>@ToString</code> to let lombok generate an
            implementation of the <code>toString()</code> method. By default, it'll print your class name, along
            with each field, in order, separated by commas.
        </p>

        <p>
            By setting the <code>includeFieldNames</code> parameter to <em>true</em> you can add some clarity (but
            also quite some length) to the output of the <code>toString()</code> method.
        </p>

        <p>
            By default, all non-static fields will be printed. If you want to skip some fields, you can name them in
            the <code>exclude</code> parameter; each named field will not be printed at all. Alternatively, you can
            specify exactly which fields you wish to be used by naming them in the <code>of</code> parameter.
        </p>

        <p>
            By setting <code>callSuper</code> to <em>true</em>, you can include the output of the superclass
            implementation of <code>toString</code> to the output. Be aware that the default implementation of
            <code>toString()</code> in <code>java.lang.Object</code> is pretty much meaningless, so you probably
            don't want to do this unless you are extending another class.
        </p>
    </div>
    <@u.comparison />
    <div class="row">
        <h3>Supported configuration keys:</h3>
        <dl>
            <dt><code>lombok.toString.includeFieldNames</code> = [<code>true</code> | <code>false</code>]
                (default:
                true)
            </dt>
            <dd>Normally lombok generates a fragment of the toString response for each field in the form of
                <code>fieldName
                    = fieldValue</code>. If this setting is set to <code>false</code>, lombok will omit the name
                of the
                field and simply deploy a comma-separated list of all the field values. The annotation parameter
                '<code>includeFieldNames</code>', if explicitly specified, takes precedence over this setting.
            </dd>
            <dt><code>lombok.toString.doNotUseGetters</code> = [<code>true</code> | <code>false</code>]
                (default:
                false)
            </dt>
            <dd>If set to <code>true</code>, lombok will access fields directly instead of using getters (if
                available) when generating <code>toString</code> methods. The annotation parameter
                '<code>doNotUseGetters</code>',
                if explicitly specified, takes precedence over this setting.
            </dd>
            <dt><code>lombok.toString.flagUsage</code> = [<code>warning</code> | <code>error</code>] (default:
                not
                set)
            </dt>
            <dd>Lombok will flag any usage of <code>@ToString</code> as a warning or error if configured.</dd>
        </dl>
    </div>
    <div class="row">
        <h3>Small print</h3>

        <div class="smallprint">
            <p>
                If there is <em>any</em> method named <code>toString</code> with no arguments, regardless of
                return
                type, no method will be generated, and instead a warning is emitted explaining that your
                <code>@ToString</code>
                annotation is doing nothing. You can mark any method with
                <code>@lombok.experimental.Tolerate</code>
                to hide them from lombok.
            </p>

            <p>
                Arrays are printed via <code>Arrays.deepToString</code>, which means that arrays that contain
                themselves will result in <code>StackOverflowError</code>s. However,
                this behaviour is no different from e.g. <code>ArrayList</code>.
            </p>

            <p>
                Attempting to exclude fields that don't exist or would have been excluded anyway (because they
                are
                static) results in warnings on the named fields.
                You therefore don't have to worry about typos.
            </p>

            <p>
                Having both <code>exclude</code> and <code>of</code> generates a warning; the
                <code>exclude</code>
                parameter will be ignored in that case.
            </p>

            <p>
                We don't promise to keep the output of the generated <code>toString()</code> methods the same
                between lombok versions. You should never design your API so that
                other code is forced to parse your <code>toString()</code> output anyway!
            </p>

            <p>
                By default, any variables that start with a $ symbol are excluded automatically. You can only
                include them by using the 'of' parameter.
            </p>

            <p>
                If a getter exists for a field to be included, it is called instead of using a direct field
                reference. This behaviour can be suppressed:<br/>
                <code>@ToString(doNotUseGetters = true)</code>
            </p>

            <p>
                <code>@ToString</code> can also be used on an enum definition.
            </p>
        </div>
    </div>
</div>
</@u.page>

