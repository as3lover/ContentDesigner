/**
 * Created by Morteza on 4/19/2017.
 */
package src2
{
public class Fonts
{
    public static const YEKAN:String = 'B Yekan';
    public static const NAZANIN:String = 'B Nazanin';
    public static const FONTS:Object = {YEKAN:'B Yekan', NAZANIN:'B Nazanin', NAZANIN_BOLD:'B Nazanin Bold',
                                        ELHAM:'B Elham', ELHAM_BOLD:'B Elham Bold', DAVAT:'B Davat', ESFAHAN:'B Esfehan',
                                        HAMID:'B Hamid'
                                       };

    [Embed(source="../../assets/fonts/B Yekan.TTF",
            fontName = "B Yekan",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="true")]
    private var YekanFont:Class;

    [Embed(source="../../assets/fonts/B Nazanin.TTF",
            fontName = "B Nazanin",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="true")]
    private var NazaninFont:Class;

    [Embed(source="../../assets/fonts/B Nazanin Bold.TTF",
            fontName = "B Nazanin Bold",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="true")]
    private var NazaninBoldFont:Class;

    [Embed(source="../../assets/fonts/B Davat.TTF",
            fontName = "B Davat",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="true")]
    private var DavatFont:Class;

    [Embed(source="../../assets/fonts/B Elham.TTF",
            fontName = "B Elham",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="true")]
    private var ElhamFont:Class;

    [Embed(source="../../assets/fonts/B Elm Bold.TTF",
            fontName = "B Elham Bold",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="true")]
    private var ElhamBoldFont:Class;

    [Embed(source="../../assets/fonts/B Esfehan Bold.TTF",
            fontName = "B Esfehan",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="true")]
    private var EsfehanFont:Class;

    [Embed(source="../../assets/fonts/B Hamid.TTF",
            fontName = "B Hamid",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="true")]
    private var HamidFont:Class;

    public function Fonts()
    {
    }
}
}

