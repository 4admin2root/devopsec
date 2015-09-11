import weblogic.servlet.logging.CustomELFLogger;
import weblogic.servlet.logging.FormatStringBuffer;
import weblogic.servlet.logging.HttpAccountingInfo;

public class WlsXff implements CustomELFLogger
{
public void logField(HttpAccountingInfo metrics, FormatStringBuffer buff)
{
buff.appendValueOrDash(metrics.getHeader("X-Forwarded-For"));
}
}

