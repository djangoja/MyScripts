**简单指南**
  这儿有一系列简单的指南帮助用户开始模拟。更为详细的实例教程可以在这网站找到：[http://www.mdtutorials.com/](http://www.mdtutorials.com/)

# 初学者
  对于那些刚刚开始学习GROMACS或分子动力学模拟的人来说是非常艰难的。强烈建议首先阅读那些为GROMACS提供的各种广泛的文档，以及在感兴趣领域出版的文章。
## 资源
  * GROMACS[参考手册](http://manual.gromacs.org/documentation/2019/reference-manual/index.html)---非常详细的文档，通常也可以作为一个非常好的MD介绍。
  * [流程图](http://manual.gromacs.org/documentation/2019/user-guide/flow.html)---一个蛋白在水盒子中的典型GROMACS分子动力学流程。
  * 分子动力学模拟和GROMACS介绍([幻灯片](https://extras.csc.fi/chem/courses/gmx2007/Berk_talks/forcef.pdf)，[视频](http://tv.funet.fi/medar/showRecordingInfo.do?id=/metadata/fi/csc/courses/gromacs_workshop_2007/IntroductiontoMolecularSimulationandGromacs_1.xml))---力场，积分以及温度和压力的控制（Berk Hess）

# 添加残基到力场中

## 添加新的残基
  如果你有需要将新的残基添加到已经存在的力场中去以便能够使用[pdb2gmx](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-pdb2gmx.html#gmx-pdb2gmx)，或者修改存在的残基，那么有几个文件你应该修改。你必须参阅[参考手册](http://manual.gromacs.org/documentation/2019/reference-manual/index.html)对于所需格式的描述部分。执行以下步骤：
  * 向你选择的力场中的[rtp](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#rtp)文件中添加残基.你也可以复制一个已经存在的残基，重命名和适当地修改它，或者你可能需要使用额外的拓扑生成工具并调整其为[rtp](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#rtp)格式。
  * 如果需要氢原子能够添加到你的残基中，请在相关的[hdb](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#hdb)文件中创建项目。
  * 如果你正引入新的原子类型，请添加它们进入 **atomtypes.atp** 和 **ffnonbonded.itp** 文件中。
  * 如果你需要一些新的成键类型，请添加它们到 **ffbonded.itp** 文件中。
  * 使用正确的指定（Protein，DNA，Ion等）将你的新残基添加到 **residuetypes.dat** 文件中。
  * 如果你的残基与其他残基涉及特殊连接，请更新 **specbond.dat** 。
  **注意：** 如果你正在模拟一些非自然配体在水中或者它们与正常蛋白质的结合，那么上述的工作远比产生一个独立的包含 **[moleculetype]** 部分的[itp](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#itp)文件要多（例如：通过修改由一些参数化服务器产生的[top](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#top)文件），并将该[itp](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#itp)文件的 **#include** 插入到为系统生成的那个没有非自然配体的[top](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#top)中。

## 修改力场
  修改力场的最佳方法是复制已安装的forcefield目录和 **residuetypes.dat** 到你的工作路径下：
```
cp -r $GMXLIB/residuetypes.dat $GMXLIB/amber99sb.ff .
```
  然后，按照上面的方法修改这些本地副本。[pdb2gmx](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-pdb2gmx.html#gmx-pdb2gmx)将同时找到原始版本和修改后的版本，你可以从列表中交互式地选择修改后的版本，或者如果使用[pdb2gmx](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-pdb2gmx.html#gmx-pdb2gmx) 的 **-ff** 选项，本地版本将覆盖系统版本。

# 水溶剂
  当使用[solvate](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-solvate.html#gmx-solvate)产生溶剂盒子时，你需要提供一个预先平衡好的盒子，里面装着合适的溶剂，让溶剂在你的溶质周围堆积。然后截断得到你想要的模拟体积大小。当使用3点水模型（例如 **SPC** ， **SPC/E** 或 **TIP3P** ）时你应该指定 **-cs spc216.gro**，这将使用 **the gromacs/share/top**路径下的文件。其他的水分子模型（例如 **TIP4P** 和 **TIP5P** ）也有。检查 **/share/top** 子目录下的内容。溶剂化以后，你应该确保在期望的温度下平衡至少5-10ps。您需要在[top](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#top)文件中选择正确的水模型，或者使用[pdb2gmx](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-pdb2gmx.html#gmx-pdb2gmx)的 **-water** 选项指定，或者手工适当地编辑[top](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#top)文件。
  有关如何使用除纯水以外的溶剂的信息，请参阅[非水溶剂化](http://manual.gromacs.org/documentation/2019/how-to/topology.html#gmx-solvate-other)或[混合溶剂](http://manual.gromacs.org/documentation/2019/how-to/topology.html#gmx-solvate-mix)。

# 非水溶剂
  在GROMACS中可以使用除水以外的溶剂。唯一的要求是你有一个你所需要的溶剂预先平衡的盒子，和为这个模拟合适的参数。然后使用[solvate](http://manual.gromacs.org/documentation/current/onlinehelp/gmx-solvate.html#gmx-solvate)的 **-cs** 选项即可完成溶剂化。
  在[virtualchemistry](http://virtualchemistry.org/)中，可以找到一系列大约150种不同的平衡液体，这些液体经过验证可以与GROMACS一起使用，也可以用于OPLS/AA和GAFF力场。

## 制作非水溶剂盒子
  选择一个盒子的密度和大小。尺寸不必是您最终的模拟盒的大小—一个1nm的立方体可能就可以了。成单个溶剂分子。计算出一个分子在你选择的密度和大小的盒子里的体积。使用[editconf](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-editconf.html#gmx-editconf)在单个分子周围放置一个同样大小的盒子。然后用[editconf](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-editconf.html#gmx-editconf)将分子移动到中心。然后使用[genconf](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-genconf.html#gmx-genconf) 的 **-rot** 选项把那个盒子复制成一个大小和密度都合适的大盒子。然后使用NVT和周期性边界条件彻底平衡来去除分子的不正确排列。现在你有了一个可以传递给[solvate ](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-solvate.html#gmx-solvate) 的 **-cs** 选项，它将复制以适应实际模拟体系的大小。

# 混合溶剂
  新用户面临的一个常见问题是如何创建一个混合溶剂(例如，在给定浓度的水中使用尿素或DMSO)的系统。完成这项工作最简单的程序如下:
  * 根据系统的盒形尺寸，确定所需的共溶剂分子数量。
  * 生成一个单分子共溶剂的坐标文件（例如urea.gro）。
  * 使用[gmx insert-molecules](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-insert-molecules.html#gmx-insert-molecules)的 **-ci** 和 **-nmol** 选项将所需的共溶剂分子数目添加到盒中。
  * 使用[gmx solvate](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-solvate.html#gmx-solvate) 或者 [gmx insert-molecules](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-insert-molecules.html#gmx-insert-molecules)把盒子的其余部分装满水（或者其他溶剂分子）
  * 编辑你的[top](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#top)并 **#include** 适当的[itp](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#itp)文件，并对 **[molecules]** 部分进行更改，以说明系统中的所有分子类型。

# 制作二硫键
  最简单的方法是使用 **specbond.dat** 文件和[pdb2gmx](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-pdb2gmx.html#gmx-pdb2gmx)实现的机制。您可能会发现[pdb2gmx](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-pdb2gmx.html#gmx-pdb2gmx)的 **-ss yes** 非常有用。需要在同一单元的硫原子在[pdb2gmx](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-pdb2gmx.html#gmx-pdb2gmx)转换为一个 **moleculetype**，因此，可能需要正确调用[pdb2gmx](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-pdb2gmx.html#gmx-pdb2gmx)的 **-chainsep**。**pdb2gmx -h**以查看功能。这就要求两个硫原子之间的距离必须在+公差范围内(通常为10%)，这样才能被识别为二硫原子。如果你的硫原子没有这么近，那么你也可以：
  * 编辑 **specbond.dat** 的内容以允许成键，并且做能量最小化时要非常小心，使键放松到一个合理的长度。
  * 在这些具有较大力常数的硫原子之间运行使用距离约束(且没有二硫键)的初步EM或MD，使它们接近现有 **specbond.dat** 范围，以便为第二次调用[pdb2gmx](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-pdb2gmx.html#gmx-pdb2gmx)提供合适的坐标文件。
  否则，手工编辑你的[top](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#top)文件是唯一的选择。
# GROMACS运行膜的模拟

## 运行膜模拟
  用户们在运行磷脂双分子层模拟时经常遇到问题，尤其是涉及蛋白的时候。用户在模拟膜蛋白时可能发现这个[教程](http://www.mdtutorials.com/gmx/membrane_protein/index.html)有用。
  膜蛋白模拟一般包括以下几个步骤：
  * 1.选择含有蛋白和脂类参数的力场文件
  * 2.将蛋白插入到膜中(例如，成型双层膜使用```gmx_membed```，或者做粗粒化自组装模拟，然后转换成原子表示)。
  * 3.溶解体系并添加离子使之中和多余电荷，调整最终离子浓度。
  * 4.能量最小化。
  * 5.让膜适应蛋白。一般是对全部蛋白分子的重原子使用限制（1000 kJ/(mol nm2)）运行大约5-10 ns的MD。
  * 6.取消限制进行平衡。
  * 7.运行成品MD。

## 用genbox添加水
  当使用[solvate](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-solvate.html#gmx-solvate)在预形成的脂质膜周围添加水分子时，你可能会发现水分子被加入到了膜的空隙中。这里有几种方法可以消除这些问题，包括：
  * 短时间的MD运行，依靠疏水性形象去排除掉水。一般来说这足以实现无水疏水相，因为这些分子通常会被迅速排出而不会破坏整体结构。如果您的设置在一开始就依赖于完全的无水疏水相，您可以尝试以下建议：
  * 使用[gmx solvate](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-solvate.html#gmx-solvate)的```-radius```选项去改变水的排斥半径。
  * 从你的```$GMXLIB```位置复制```vdwradii.dat```文件到你的工作目录，然后编辑它，增大脂类原子半径（碳原子一般在0.35到0.5nm）来防止溶剂进入到空隙中。
  * 手手动编辑结构以删除它们（要调整gro文件的原子计数，并考虑拓扑中的一些更修改）。。
  * 使用别人编写的脚本删除它们。

## 扩充材料
  * [膜模拟幻灯片](https://extras.csc.fi/chem/courses/gmx2007/Erik_Talks/membrane_simulations.pdf)，[膜模拟视频](http://tv.funet.fi/medar/showRecordingInfo.do?id=/metadata/fi/csc/courses/gromacs_workshop_2007/SpeedingupSimulationsAlgorithmsApplications.xml)----(Erik Lindahl)
  * GROMACS[膜蛋白模拟指南](http://www.mdtutorials.com/gmx/membrane_protein/index.html)----旨在演示在模拟嵌入到磷脂双分子层的蛋白时，会出现哪些问题。
  * 将[Berger磷脂结合OPLS-AA力场](http://www.pomeslab.com/files/lipidCombinationRules.pdf)，详细描述了该方法的动机、方法和测试。
  * 几种不同力场下（gaff，charmm，berger）膜蛋白的拓扑结构，Shirley W. I. Siu, Robert Vacha, Pavel Jungwirth, Rainer A. Böckmann: [Biomolecular simulations of membranes: Physical properties from different force fields](https://doi.org/10.1063/1.2897760)。
  * [Lipidbook](https://lipidbook.bioch.ox.ac.uk/)是一个用于存储脂类、洗涤剂和其他分子的力场参数的公共存储库，能够用来模拟膜和膜蛋白。在该文献中描述：J. Domański, P. Stansfeld, M.S.P. Sansom, and O. Beckstein. J. Membrane Biol. 236 (2010), 255—258. [doi:10.1007/s00232-010-9296-8](http://dx.doi.org/10.1007/s00232-010-9296-8).

# 新分子参数化
  大多数参数化问题/困难都可以很简单地解决，只要记住以下两条规：
  * 你不应该混合和匹配力场。[力场](http://manual.gromacs.org/documentation/2019/user-guide/terminology.html#gmx-force-field)(最好)被设计成自洽的，通常不能很好地与其他力场协同工作。如果你用一个力场来模拟系统的一部分，另一部分用另一个不同的力场来模拟而不是用第一个力场来参数化，您的结果可能会有问题，审阅人员会关注。选择一个力场，就要用那一个力场。
  * 如果您需要开发新的参数，请按照原力场其余部分的推导方式推导它们，这意味着你需要看原始文献。推导力场参数没有单一正确的方法；你需要的是推导出与力场其余部分一致的参数。怎么做取决于你想用哪个力场。例如,利用AMBER力场，推导非标准氨基酸的参数可能需要进行许多不同的量子计算，而推导GROMOS或OPLS参数可能涉及更多 **（a）** 拟合各种流体和液相性质。 **（b）** 根据经验/化学知识/类比调整参数。[这里](http://manual.gromacs.org/documentation/2019/user-guide/system-preparation.html)可以找到一些关于自动化方法的建议。
  

  在尝试参数化新力场或者现有力场的新分子之前，对GROMACS有一定的仿真经验是明智的，这些都是专家话题，不适合给本科生做研究项目，除非你喜欢昂贵的准随机数生成器。需要非常全面地了解GROMACS参考手册第5章。如果你还没有足够了解，请阅读下面关于外来物种参数化的内容。
  另一个建议是:在获取参数时，不要过于随意，否则就会买到高档珠宝。仅仅因为街上有人愿意以10美元的价格卖给你一条钻石项链，并不意味着你应该在那里买一条。同样，从你从未听说过的人的网站上下载你感兴趣的分子的参数也不一定是最好的策略，尤其是如果他们不解释他们是如何得到这些参数的。
  预先警告使用[PRODRG](http://davapc1.bioch.dundee.ac.uk/cgi-bin/prodrg)拓扑而不验证其内容:现已[出版](http://pubs.acs.org/doi/abs/10.1021/ci100335w)，以及一些技巧，以正确地推导参数的GROMOS力场。

## 外来物种

  所以，你想要模拟一个蛋白质/核酸系统，但是它会结合各种其他的金属离子(钌?），或者有一个铁硫团簇对其功能至关重要，或者相似的。但是，(不幸的是?)在你想要使用的力场中没有这些参数可用。你应该怎么做?您可以向GROMACS用户的电子邮件列表发送电子邮件，并获得常见问题解答。
  如果你真的坚持在分子动力学中模拟它们，你需要获得它们的参数，或者从文献中，或者通过你自己的参数化。但在这之前，停下来想一想可能是很重要的，因为有时可能存在这样的原子/团簇参数不存在的原因。特别地，这里有几个基本的问题，你可以问你自己，看看是否合理地开发/获得这些标准参数，并在分子动力学中使用它们:
  * 量子效应(即电荷转移)可能很重要吗?(即。，如果你有一个二价金属离子在酶活性位点，并有兴趣研究酶的功能，这可能是一个巨大的问题)。
  * 在我所选择的力场中使用的标准力场参数化技术在这种类型的原子/簇中可能会失败吗?(例如，Hartree-Fock 6-31G*不能充分描述过渡金属)。


  如果这两个问题的答案都是“是”，你可能会考虑用经典分子动力学以外的东西来做模拟。
  即使这两个问题的答案都是“不”，在尝试自己的参数化之前，您可能也想咨询一下您感兴趣的化合物的专家。此外，在开始这些操作之前，您可能想尝试对一些更直接的东西进行参数化。

# 平均力势
  平均力势(PMF)定义为：在给定系统的所有构型上给出平均力的势。在GROMACS中有几种计算PMF的方法，其中最常见的可能是使用pull代码。使用伞形采样，它允许对统计上不可能的状态进行抽样，获得PMF的步骤如下:
  * 沿着反应坐标生成一系列构象(从SMD模拟、常规MD模拟或任意生成的构象)
  * 使用伞形抽样在抽样窗口内限制这些构象。
  * 利用[gmx wham](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-wham.html#gmx-wham)，使用WHAM算法重构PMF曲线。


这里[链接](http://www.mdtutorials.com/gmx/umbrella/index.html)了一个更详细的教程，用于伞形抽样。

# 单点能
计算单个构象的能量有时是有用。GROMACS的最佳方法是使用[mdrun](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-mdrun.html#gmx-mdrun)的```-rerun```选项，该选项将[tpr](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#tpr)中的物理模型应用于轨迹或坐标文件中的构象，并提供给mdrun。
```
mdrun -s input.tpr -rerun configuration.pdb
```
注意，所提供的构象必须与使用[grompp](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-grompp.html#gmx-grompp)生成[tpr](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#tpr)文件时使用的拓扑相匹配。您提供给[grompp](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-grompp.html#gmx-grompp)的构象除了原子名称之外，都无关紧要。您还可以将此功能用于能量组（看[参考手册](http://manual.gromacs.org/documentation/2019/manual-2019.pdf)），或者用多构型轨迹（在本例中，默认情况下mdrun将对每个构象执行邻居搜索，因为它不能假设输入是相似的)。

零步能量最小化在报告能量之前执行一个步骤，而零步MD运行具有(可避免的)并发症，这些并发症与在存在约束的情况下可能重新启动有关，因此不推荐使用这两种程序。

# 碳纳米管

## Robert Johnson的技巧
  采纳了Robert Johnson在gmx-users mailing list上的帖子。
  * 要绝对保证拓扑文件中“末端”碳原子是共享一个键。
  * [gmx grompp](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-grompp.html#gmx-grompp)时的[mdp](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#mdp)输入文件要使用**periodic_molecules = yes**。
  * 即使拓扑文件正确，如果你把碳纳米管放置在错误尺寸的盒子里将使得扭曲发生。因此使用[VMD](http://www.ks.uiuc.edu/Research/vmd/)可视化纳米管和它的周期性成像，确保镜像之间的空隙正确。如果空隙太小或太大，在纳米管上将有巨大的压力导致其扭曲或拉伸。
  * 沿着碳纳米管的轴线方向上不要使用压力耦合。事实上，为了调试目的，如果发生某些错误，可能先最好关掉整个压力耦合直到你弄清楚是什么问题。
  * 当使用具有特定力场的[x2top](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-x2top.html#gmx-x2top)时，假设分子的连接性。如果是周期性的，亦或者是非周期性上面有氢原子，那么你的纳米管末端的碳原子最多只能和两个其他分子相结合。
  * 你可以使用[x2top](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-x2top.html#gmx-x2top)工具中的 **-pbc** 选项产生一个无限长的纳米管，这里[x2top](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-x2top.html#gmx-x2top)将识别为末端C原子共享一个化学键。因此，当你使用[grompp](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-grompp.html#gmx-grompp)时不会得到关于单个碳原子的报错。

## Andrea Minoia的指南

  GROMACS模拟碳纳米管（也可以参看：[http://www.webcitation.org/66u2xJJ3O](http://www.webcitation.org/66u2xJJ3O)）

  **原文翻译**

  **使用GROMACS模拟碳纳米管**

  网上有许多关于GROMACS和CNTs的文献（[1](http://www.gromacs.org/Documentation/How-tos/Carbon_Nanotube),[2](http://cs86.com/CNSE/SWNT.htm),[3](http://machine-phase.blogspot.com/2009/04/single-wall-carbon-nanotubes-in-403.html)，[...](http://www.google.be/search?hl=en&source=hp&q=cnt+gromacs&btnG=Google+Search&meta=&aq=f&oq=)）。即使读了很多，我也没有找到我想要的：一个清楚、简单的模拟单壁碳纳米管和多壁碳纳米管（SWNT，MWNT）指南，周期或者非周期性。
  我花了一段时间才找到步骤做这些我想做的事情：构建一个周期性CNT并创建GROMACS的拓扑文件。

  ## 构建和准备CNT
  第一步很明显是构建CNT，例如采用 [YASC buildCstruct](http://chembytes.wikidot.com/buildcstruct)。使用这个插件可以构建SWCNT和MSWCNT，包括armchair或zigzag型，有限的或周期性的。从 v1.1版本开始，**buildCstruct**能够直接保存为grmacs的GRO格式文件。
  **注意要有一个足够大的晶胞容纳所有的CNT，否则你将不能产生拓扑文件。你能够使用ngmx，molden或者vmd的pbc检查结构。而且，也要注意选择一个足够大的盒子去容纳其他你想和CNT接触的分子，例如聚合物链。**
  
  ## 为x2top准备的文件
  x2top需要一堆文件来创建拓扑文件。我想使用oplsaa力场。但是我不想搞乱**share/gromacs/top**目录中的原始ffoplsaa文件，因此我自己创建了我需要的文件。

  ### .n2t itp
  此文件用于在拓扑中转换名称。根据它的连接性读取结构中原子的名称（例如成键数，键长和原子结合），根据.n2t文件中定义的尝试去猜合适的原子类型。我的基于oplsaa力场的石墨烯和CNT的.n2t文件如下：
```
; Oplsaa-based n2t for carbon-based structures such as CNTs and graphenes
; Andrea Minoia
H    HJ    0.00       1.008  1    C 0.109                              ;Hydrogen
C    CJ    0.00      12.011  3    C 0.142   H 0.109   H 0.109 ;Periferic C
C    CJ    0.00      12.011  3    C 0.142   C 0.142   H 0.108 ;Periferic C
C    CJ    0.00      12.011  1    C 0.142                          ;Internal/periodic C
C    CJ    0.00      12.011  2    C 0.142   C 0.142            ;Internal/periodic C
C    CJ    0.00      12.011  3    C 0.142   C 0.142   C 0.142 ;Internal/periodic C
```
  我决定把所用的电荷设置为0，但是你可能想不一样。

  ### .itp文件
  我更喜欢不让x2top将力场参数放入拓扑文件中，我已经定义了我自己的.itp文件：
```
; Oplsaa-based force field for carbon-based structures such as CNTs and graphenes
; Andrea Minoia

[ defaults ]
; nbfunc        comb-rule       gen-pairs       fudgeLJ fudgeQQ
1               3               yes             0.5     0.5
; parameters are taken from the OPLS force field

[ atomtypes ]
; The charges here will be overwritten by those in the rtp file
; name       mass      charge    ptype      sigma      eps
  CJ   6     12.01100     0.000       A    3.55000e-01  2.92880e-01 ;opls_147 naftalene fusion C9
  HJ   1      1.00800     0.000       A    2.42000e-01  1.25520e-01 ;opls_146 HA hydrogen benzene. I have set the charges zero

[ bondtypes ]
; i    j func        b0          kb
  CJ    CJ      1    0.14000   392459.2   ; TRP,TYR,PHE
  CJ    HJ      1    0.10800   307105.6   ; PHE, etc.

[ angletypes ]
  CJ     CJ     CJ      1   120.000    527.184   ; PHE(OL)
  CJ     CJ     HJ      1   120.000    292.880   ;
  HJ     CJ     HJ      1   117.000    292.880   ; wlj from HC-CM-HC

[ dihedraltypes ]
  CJ     CJ     CJ     CJ      3     30.33400   0.00000 -30.33400   0.00000   0.00000   0.00000 ; aromatic ring
  HJ     CJ     CJ     HJ      3     30.33400   0.00000 -30.33400   0.00000   0.00000   0.00000 ; aromatic ring
  HJ     CJ     CJ     CJ      3     30.33400   0.00000 -30.33400   0.00000   0.00000   0.00000 ; aromatic ring
```
目前没有二面角。
  ### .rtp 文件
  最后，我需要创建oplsaa的残基拓扑文件，这里还没有定义任何残基。
```
; New format introduced in Gromacs 3.1.4.
; Dont use this forcefield with earlier versions.

; Oplsaa-based rtp for carbon-based structures such as CNTs and graphenes
; Andrea Minoia

; NB: OPLS chargegroups are not strictly neutral, since we mainly
; use them to optimize the neighborsearching. For accurate simulations
; you should use PME.

[ bondedtypes ]
; Col 1: Type of bond
; Col 2: Type of angles
; Col 3: Type of proper dihedrals
; Col 4: Type of improper dihedrals
; Col 5: Generate all dihedrals if 1, only heavy atoms of 0.
; Col 6: Number of excluded neighbors for nonbonded interactions
; Col 7: Generate 1,4 interactions between pairs of hydrogens if 1
; Col 8: Remove propers over the same bond as an improper if it is 1
; bonds  angles  dihedrals  impropers all_dihedrals nrexcl HH14 RemoveDih
     1       1          3          1        0         3      1     0
```
  ### FF.dat文件
  这里我指定了力场的名字：
```
1
ffcnt_oplsaa
```
  ## 使用x2top创建拓扑
  一旦所有文件准备好，就可以使用x2top产生拓扑：
```
x2top -f file.gro -o topol.top -ff cnt_oplsaa -name CNT -noparam -pbc
```
  **-pbc**选项将产生那些周期性边界条件的所有键，角度和二面角（这就是为什么.gro文件中需要指定合适大小的盒子单元）。如果你对纳米管不是周期性的，那就不需要 **-pbc** 。
  ## 矫正拓扑
  最后一步是将用来描述二面体的函数从**1**更改为**3**。
  ## .mdp文件
  在你的mdp文件中打开周期性选项：
```
periodic_molecules=yes
pbc = xyz
```
  这就是全部...现在你已经可以模拟周期性碳纳米管或碳基结构。
  ## 溶解CNT
  为了溶解CNT，我们能够使用GROMACS的genbox工具（gromacs5.0版本以上改为了solvate）采用-cp（纳米管的gro文件）和-cs（溶解的盒子gro文件）。
  通常，我首先在NPT下平衡溶剂盒子，然后创建了一个比CNT盒子更大的超胞。这是因为溶质盒子（-cp）将成为最终系统的盒子。
  genbox将尝试用溶剂分子填充盒子空隙，甚至在CNT的内部。如果这不可取，我们能写一个创建索引文件的脚本，该文件不包含CNT内部分子中原子的原子索引。然后，使用editconf去产生最终体系：
```
editconf -f starting_system.gro -n index.ndx -o final_system.gro
```
  ### 使用YSAC nosolincnt去除CNT内部的原子
  与editconf一起使用的引索文件是为了去除CNT内部的溶剂分子，这能够佷容易通过YSAC nosolincnt编写，它是一个VMD插件。
  用VMD读取体系后，打开TCL控制台，执行插件：
```
source /path/of/the/script/nosolincnt.tcl
```
  将提示你插入CNT的片段数和CNT半径（埃米）。这些信息将用于创建一个圆柱形，根据CNT质心X，Z坐标得到的半径。当视图窗口处于激活状态时，你能按 **C** 去检查选择的结果。如果一切正确，然后按 **W** 将会写入引索文件而不需要选择原子。
  在下面的图片中，分别显示了溶剂化后的碳纳米管、要除去的分子和最终的体系。
  ![CNT体系](https://github.com/liuyujie714/Scripts/blob/master/cnt.jpg)

  ### 复合物实例：溶解CNT+聚合物
  我真的不知道有什么兴趣可以单独建立一个溶剂化碳纳米管模型，当然，如果我们加入聚合物，事情会变得更有趣。在下面的流程图中，我发现溶剂化CNT与聚合物链相互作用。
  ![CNT+聚合物模拟流程图](https://github.com/liuyujie714/Scripts/blob/master/flowchart_polysolcnt.png)
  ## 故障排除，提示和技巧
  ### Grompp时提示原子名不匹配
  如果您以pdb文件开始生成gro文件，根据您如何生成pdb文件，可能会丢失残基名称。在这种情况下，我经历了grompp的一系列警告：
```
Warning: atom name X in _FILE.top_ and _FILE.gro_ does not match...
```
  我通过在.gro和.top文件中添加一个残基名称来解决这个问题。

  ### VI编辑
  学习它!它是您最好的伙伴，特别是在使用gromacs和大型文本文件时。
  
-----
  包括了使用OPLS-AA力场设置一个CNT模拟的详细步骤。一个CNT的结构可以很容易通过[buildCstruct](http://chembytes.wikidot.com/buildcstruct)（此Python脚本也可以加氢）或者通过[TubeGen Online](http://turin.nss.udel.edu/research/tubegenonline.html)（只需要复制和粘贴PDB输出到文件并命名为cnt.pdb）。
  为了能够用GROMACS模拟，你可能要执行以下操作：
  * 新建一个cnt_oplsaa.ff目录文件夹
  * 在此目录下，创建如下文件，以下步骤来源于上面的指南：
    * forcefield.itp来自[itp](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#itp)部分文件。
    * atomnames2types.n2t来自[n2t](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#n2t)部分文件。
    * aminoacids.rtp来自[rtp](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#rtp)部分文件。
  * 使用传统的力场产生拓扑（cnt_oplsaa.ff目录文件必须与[gmx x2top](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-x2top.html#gmx-x2top)命令执行的目录相同，亦或者它能够在GMXLIB路径中找到），采用[gmx x2top](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-x2top.html#gmx-x2top)的 **-noparam** 选项，不使用来自命令行（-kb, -ka, -kd）指定的bond/angle/dihedral等常数，而是依赖力场文件；然而，这就需要下一步（确定二面角函数）
```
gmx x2top -f cnt.gro -o cnt.top -ff cnt_oplsaa -name CNT -noparam
```
二面角的函数类型通过[gmx x2top](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-x2top.html#gmx-x2top)设置为“1”，但是力场文件指定的函数类型为“3”。因此，替换拓扑文件中 **[ dihedrals ]** 部分的”1“为”3“。一种快速的方式是使用 **sed**（但是你可能需要调整你的操作系统；也要手动看一下top文件核查一下你更改的二面角函数类型）：
```
sed -i~ '/\[ dihedrals \]/,/\[ system \]/s/1 *$/3/' cnt.top
```
一旦你有了拓扑文件，你就可以设置你的系统了。例如，一个简单的 真空模拟（在[em.mdp](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#mdp)和[md.mdp](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#mdp)中使用你自己的参数）：
放入一个稍微大的盒子中：
```
gmx editconf -f cnt.gro -o boxed.gro -bt dodecahedron -d 1
```
真空中的能量最小化：
```
gmx grompp -f em.mdp -c boxed.gro -p cnt.top -o em.tpr
gmx mdrun -v -deffnm em
```
真空中的MD：
```
gmx grompp -f md.mdp -c em.gro -p cnt.top -o md.tpr
gmx mdrun -v -deffnm md
```
查看轨迹：
```
gmx trjconv -f md.xtc -s md.tpr -o md_centered.xtc -pbc mol -center
gmx trjconv -s md.tpr -f md_centered.xtc -o md_fit.xtc -fit rot+trans
vmd em.gro md_fit.xtc
```

# 可视化软件
为了可视化轨迹文件/坐标文件，一些程序是有用：
  * [VMD](http://www.ks.uiuc.edu/Research/vmd/)----一种分子可视化程序，用于显示、动画和分析大型生物分子系统，使用三维图形和内置脚本。读取GROMACS轨迹。
  * [PyMOL](http://www.pymol.org/)----支持动画、高质量渲染、晶体学和其他常见分子图形活动的功能强大的分子查看器。不读取默认配置中的GROMACS轨迹，需要转换为PDB或类似格式。当使用VMD插件编译时，可以加载trr & xtc文件。
  * [Rasmol](http://www.umass.edu/microbio/rasmol/index2.htm)----派生软件Protein Explorer(如下)可能是更好的选择，但是Chime组件需要windows。Rasmol在Unix上工作得很好。
  * [Protein Explorer](http://www.umass.edu/microbio/rasmol/)----一个RasMol衍生物，是最容易使用和最强大的软件，以查看大分子结构及其与功能的关系。它运行在Windows或Macintosh/PPC电脑上。
  * [Chimera](http://www.rbvi.ucsf.edu/chimera/)----一个功能齐全的，基于python的可视化程序，具有各种功能，可以在任何平台上使用。当前版本读取GROMACS轨迹。
  * [Molscript](http://www.avatar.se/molscript/)----这是一个脚本驱动程序形式的高质量显示分子三维结构的示意图和详细的表示。你可以从Avatar免费获得学术许可。


此外，如果在配置时找到了合适的库，[gmx view](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-view.html#gmx-view)也会很有用。

## 拓扑成键 vs 渲染的键
请记住，这些可视化工具只查看您提供的坐标文件(除非您提供**gmx view**一个tpr文件)。因此它没有使用拓扑文件或tpr文件中描述的拓扑。这些程序中的每一个都对化学键的位置做出自己的猜测，以便进行呈现，所以如果启发式并不总是与您的拓扑结构匹配，不要感到惊讶。

# 提取轨迹信息
在GROMACS弹道文件([trr](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#trr)、[xtc](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#xtc)、[tng](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#tng))中查找信息有几种可用的技术。
  * 使用GROMACS轨迹分析工具。
  * 使用[gmx traj](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-traj.html#gmx-traj)编写一个xvg文件，并像上面那样在外部程序中读取该文件。
  * 使用 **gromacs/share/template/template.cpp** 作为模板编写自己的C代码。
  * 使用[gmx dump](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-dump.html#gmx-dump)将shell输出重定向到一个文件，然后在外部程序(如MATLAB、Mathematica或其他电子表格软件)中读取该文件。


# 外部工具执行轨迹分析
近年来，一些外部工具已经足够成熟，可以从多个仿真包中分析不同的轨迹数据集。下面是一个简短的列表，已知能够分析GROMACS轨迹数据的工具。
  * [MDTraj](http://mdtraj.org/latest/index.html)
  * [MDAnalysis](https://www.mdanalysis.org/)
  * [LOOS](http://loos.sourceforge.net/)


# 绘制数据
各种GROMACS分析实用程序可以生成[xvg](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#xvg)文件。这些是专门为直接在Grace中使用而格式化的文本文件。但是，您可以在所有GROMACS分析程序中使用-xvg none选项运行程序来关闭Grace特定的代码。这就避免了gnuplot和Excel等工具的问题(参见下面)。

注意，Grace使用一些嵌入的反斜杠代码来表示单位中的上标、普通脚本等。面积(Area (nmS2N))等于nm²。

## 软件
一些软件包，可用于图形数据在一个xvg文件:
  * Grace ---- WYSIWYG 2D绘图工具，用于X窗口系统和M*tif。Grace几乎可以运行在任何版本的类unix操作系统上，只要您能够满足它的库依赖关系(Lesstif是Motif的一个有效的免费替代品)。它也适用于其他常见的操作系统。
  * gnuplot----可移植的命令行驱动的交互式数据和函数绘图工具，适用于UNIX、IBM OS/2、MS Windows、DOS、Macintosh、VMS、Atari和许多其他平台。记住要使用:```set datafile commentschars "#@&"```去避免gnuplot试图在xvg文件中解释Grace特定的命令，或者在运行分析程序时使用-xvg none选项。对于简单的使用：```plot "file.xvg" using 1:2 with lines```会得到正确的结果.
  * MS Excel----将文件扩展名更改为.csv并打开文件(当提示时，选择忽略前20行左右并选择固定宽度的列，如果使用德语MS Excel版本，则必须将十进制分隔符从“，”更改为“.”。，或者使用你最喜欢的*nix工具。
  * Sigma Plot----一个用于windows的商业工具，其中包含一些有用的分析工具、
  * R----为统计计算和图形提供了免费的语言和环境，提供了各种各样的统计和图形技术:线性和非线性建模、统计测试、时间序列分析、分类、聚类等。
  * SPSS----一个商业工具(统计产品和服务解决方案)，它也可以绘制和分析数据。


# 胶束聚类
如果您有一个完全形成的单一聚集体，并希望为该聚集体或该聚集体周围的溶剂生成空间分布函数，[gmx spatial](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-spatial.html#gmx-spatial)工具是必要的.
在计算诸如旋转半径和径向分布函数等性质之前，确保胶束不会在[周期边界条件](http://manual.gromacs.org/documentation/2019/user-guide/terminology.html#gmx-pbc)边界上分裂是一个必不可少的步骤。如果没有这个步骤，您的结果将是不正确的(这个错误的一个迹象是，当可视化轨迹看起来很好时，计算值会出现无法解释的巨大波动)。

需要三个步骤:
  * 使用[trjconv](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-trjconv.html#gmx-trjconv)的```-pbc cluster```获得一个包含单元细胞中所有脂类的单帧。这必须是轨道的第一帧。以前某个时间点的类似框架将不起作用。
  * 使用[grompp](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-grompp.html#gmx-grompp)根据上述步骤输出的框架创建一个新的[tpr](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#tpr)文件。
  * 使用新生成的[tpr](http://manual.gromacs.org/documentation/2019/reference-manual/file-formats.html#tpr)文件使用[trjconv](http://manual.gromacs.org/documentation/2019/onlinehelp/gmx-trjconv.html#gmx-trjconv)的 ```-pbc nojump```生成所需的轨迹。


更明确地说，同样的步骤是:
```
gmx trjconv -f a.xtc -o a_cluster.gro -e 0.001 -pbc cluster
gmx grompp -f a.mdp -c a_cluster.gro -o a_cluster.tpr
gmx trjconv -f a.xtc -o a_cluster.xtc -s a_cluster.tpr -pbc nojump
```