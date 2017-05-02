/**
 * Created by Morteza on 4/19/2017.
 */
package src2
{
public class Fonts
{
    public static const YEKAN:String = 'B Yekan';
    public static const NAZANIN:String = 'B Nazanin';
    public static const FONTS:Array =
            [
                'B Davat',
                'B Elham',
                'B Elham Bold',
                'B Esfehan',
                'B Hamid',
                'B Nazanin',
                'B Nazanin Bold',
                'B Titr',
                'B Yekan',
                'Gandom',
                'mj Tehran',
                'mj Titr DF',








            ];

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

    [Embed(source="../../assets/fonts/B Titr.TTF",
            fontName = "B Titr",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="true")]
    private var BTitrFont:Class;

    [Embed(source="../../assets/fonts/gandom.TTF",
            fontName = "Gandom",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="true")]
    private var GandomFont:Class;

    [Embed(source="../../assets/fonts/mj tehran.TTF",
            fontName = "mj Tehran",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="true")]
    private var MJ_TehranFont:Class;

    [Embed(source="../../assets/fonts/mj Titr DF.TTF",
            fontName = "mj Titr DF",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="true")]
    private var MJ_Titr_Df_Font:Class;

    public function Fonts()
    {
    }
}
}

